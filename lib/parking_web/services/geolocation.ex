defmodule Parking.Gelolocation do

  def distance(origin, destination) do
    address = "https://route.api.here.com/routing/7.2/calculateroute.json"
      query = %{
        app_id: System.get_env("ROUTES_APP_ID"),
        app_code: System.get_env("ROUTES_APP_CODE"),
        mode: "fastest;car;traffic:disabled",
        waypoint0: origin,
        waypoint1: destination
      }
      path = "#{address}?#{URI.encode_query(query)}"
      response = HTTPoison.get! path
      result = Poison.decode!(response.body)
      List.first(result["response"]["route"])["summary"]["distance"]
  end

end
