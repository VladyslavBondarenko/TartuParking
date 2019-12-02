defmodule ParkingWeb.ParkingControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.{ParkingManager, UserManager}

  @create_attrs %{location: "58.387746,26.696940", timelimit: 0, zone_id: 3, area: "58.38811045707349,26.697406020617336 58.38760994822571,26.696209755396694 58.387022263039675,26.69730409667477 58.387601512622474,26.698371615862698"}
  @update_attrs %{timelimit: 120}
  @invalid_attrs %{location: nil}

  setup %{conn: conn} do
    {_, jwt, _} = UserManager.token_sign_in("ivan","123");
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all parkings", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :index))
      assert [
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.387746,26.696940",
          "realTimePayment" => 0.0,
          "timelimit" => 0
        },
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.379579,26.708482",
          "realTimePayment" => 0.0,
          "timelimit" => 0
        },
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.382548,26.709504",
          "realTimePayment" => 0.0,
          "timelimit" => 0
        },
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.378390,26.738600",
          "realTimePayment" => 0.0,
          "timelimit" => 0
        },
        %{
          "capacity" => 20,
          "emptySpaces" => 20,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.375391,26.736067",
          "realTimePayment" => 0.0,
          "timelimit" => 0
        }
      ] = json_response(conn, 200)["parkings"]
    end
  end

  describe "create parking" do
    test "renders parking when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @create_attrs)
      assert %{"id" => id} = json_response(conn, 200)
      conn = get(conn, Routes.parking_path(conn, :show, id))
      assert %{
              "id" => id,
              "location" => "58.387746,26.696940",
              "timelimit" => 0
            } = json_response(conn, 200)
    end
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update parking" do
    test "renders parking when data is valid", %{conn: conn} do
      parking_id = 1
      conn = get(conn, Routes.parking_path(conn, :show, parking_id))
      assert %{ "timelimit" => 0 } = json_response(conn, 200)
      conn = put(conn, Routes.parking_path(conn, :update, parking_id), parking: @update_attrs)
      conn = get(conn, Routes.parking_path(conn, :show, parking_id))
      assert %{ "timelimit" => 120 } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      parking = ParkingManager.get_parking!(1)
      conn = put(conn, Routes.parking_path(conn, :update, parking), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete parking" do

    test "deletes chosen parking", %{conn: conn} do
      parking = ParkingManager.get_parking!(1)
      conn = delete(conn, Routes.parking_path(conn, :delete, parking))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.parking_path(conn, :show, parking))
      end
    end
  end

  describe "find nearest parking" do

    test "parking itself is the nearest parking to it's location", %{conn: conn} do
      parking = ParkingManager.get_parking!(4)
      conn = get(conn, Routes.parking_path(conn, :nearest), location: parking.location)
      assert %{
        "parkings" => [
          %{ "location" => "58.378390,26.738600" },
          %{ "location" => "58.375391,26.736067" },
          %{ "location" => "58.382548,26.709504" }
        ]
      } = json_response(conn, 200)
    end

    test "nearest with limit", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :nearest), location: "58.386668,26.697528", limit: "2")
      assert %{
        "parkings" => [
          %{
            "location" => "58.387746,26.696940",
            "timelimit" => 0
          },
          %{
            "location" => "58.382548,26.709504",
            "timelimit" => 0
          }
        ]
      } = json_response(conn, 200)
    end

    # neares parking should be found by the shortest car path to it, not by shortest geo-distance
    # in this test nearest by distance is closer, but path to it is longer, because this parking is on another riverside
    test "nearest by path, not by location", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :nearest), location: "58.375644,26.739925", limit: "1") # target location
      assert %{
        "parkings" => [
          %{
            "location" => "58.378390,26.738600",
            "timelimit" => 0
          }
        ]
      } = json_response(conn, 200)
    end
  end

end
