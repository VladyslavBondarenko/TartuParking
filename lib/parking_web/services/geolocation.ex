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

end
