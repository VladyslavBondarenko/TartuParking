defmodule Parking.Geolocation do

  def distance(origin, destination) do
    address = "https://route.api.here.com/routing/7.2/calculateroute.json"
    query = %{
      app_id: System.get_env("ROUTES_APP_ID"),
      app_code: System.get_env("ROUTES_APP_CODE"),
      mode: "fastest;car;traffic:disabled",
      waypoint0: origin,
      waypoint1: destination
    }
    response = HTTPoison.get! "#{address}?#{URI.encode_query(query)}"
    result = Poison.decode!(response.body)
    List.first(result["response"]["route"])["summary"]["distance"]
  end

  def getStreetByLocation(location) do
    address = "https://reverse.geocoder.api.here.com/6.2/reversegeocode.json"
    query = %{
      app_id: System.get_env("ROUTES_APP_ID"),
      app_code: System.get_env("ROUTES_APP_CODE"),
      mode: "retrieveAddresses",
      prox: location
    }
    response = HTTPoison.get! "#{address}?#{URI.encode_query(query)}"
    result = Poison.decode!(response.body)
    List.first(List.first(result["Response"]["View"])["Result"])["Location"]["Address"]["Street"]
  end

  def isLocationInArea(location, area) do
    areaPolygon = %Geo.Polygon{coordinates: [area |> String.split(" ") |> Enum.map(fn e -> e |> String.split(",") |> Enum.map(fn e -> e |> String.to_float() end) |> List.to_tuple() end)], srid: 4326}
    locationPoint = location |> String.split(",") |> Enum.map(fn e -> e |> String.to_float() end) |> List.to_tuple()
    GeoPartition.Topo.contains? areaPolygon, locationPoint
  end

end
