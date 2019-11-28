defmodule ParkingWeb.GeolocationTest do
  use Parking.DataCase
  alias Parking.{Geolocation}

  describe "geolocation" do
    test "get distance between two locations" do
      assert Geolocation.distance("58.378335,26.738633","58.379130,26.728010") == 1948
    end

    test "get street name by location" do
      assert Geolocation.getStreetByLocation("58.379983,26.719685") == "Lossi"
    end

    test "get street name by location out of streets" do
      assert Geolocation.getStreetByLocation("58.374936,26.740644") == nil
    end
  end

end
