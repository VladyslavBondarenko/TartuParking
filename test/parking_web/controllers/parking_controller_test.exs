defmodule ParkingWeb.ParkingControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.ParkingManager
  alias Parking.ParkingManager.Parking

  @create_attrs %{
    location: "58.378609, 26.738889",
  }
  @update_attrs %{
    location: "58.378605, 26.739101"
  }
  @invalid_attrs %{location: nil}

  def fixture(:parking) do
    {:ok, parking} = ParkingManager.create_parking(@create_attrs)
    parking
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all parkings", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create parking" do
    test "renders parking when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @create_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]
      conn = get(conn, Routes.parking_path(conn, :show, id))
      assert %{
              "id" => id,
              "location" => "58.378609, 26.738889"
            } = json_response(conn, 200)["data"]
    end
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update parking" do
    setup [:create_parking]

    test "renders parking when data is valid", %{conn: conn, parking: %Parking{id: id}} do
      conn = put(conn, Routes.parking_path(conn, :update, id), parking: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.parking_path(conn, :show, id))

      assert %{
        "id" => id,
        "location" => "58.378605, 26.739101"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, parking: parking} do
      conn = put(conn, Routes.parking_path(conn, :update, parking), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete parking" do
    setup [:create_parking]

    test "deletes chosen parking", %{conn: conn, parking: parking} do
      conn = delete(conn, Routes.parking_path(conn, :delete, parking))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.parking_path(conn, :show, parking))
      end
    end
  end

  defp create_parking(_) do
    parking = fixture(:parking)
    {:ok, parking: parking}
  end
end
