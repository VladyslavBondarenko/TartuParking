defmodule ParkingWeb.StreetControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.UserManager

  setup %{conn: conn} do
    {_, jwt, _} = UserManager.token_sign_in("ivan","123");
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all streets", %{conn: conn} do
      conn = get(conn, Routes.street_path(conn, :index))
      assert [
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 2.0,
          "name" => "Lossi",
          "realTimePayment" => 0.16
        },
        %{
          "capacity" => 60,
          "emptySpaces" => 60,
          "freeFirstMinutes" => 0,
          "hourPayment" => 2.0,
          "name" => "Vabaduse puiestee",
          "realTimePayment" => 0.16
        },
        %{
          "capacity" => 100,
          "emptySpaces" => 100,
          "freeFirstMinutes" => 0,
          "hourPayment" => 1.0,
          "name" => "Vanemuise",
          "realTimePayment" => 0.08
        }
      ] = json_response(conn, 200)["streets"]
    end
  end

end
