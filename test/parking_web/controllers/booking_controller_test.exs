defmodule ParkingWeb.BookingControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.{BookingManager, UserManager, Booking, ParkingManager, Street, Zone}

  @create_attrs_out_of_paid_zone %{startDateTime: "2019-11-21 18:52:29.360", location: "58.377201,26.688620"}
  @create_attrs_zone_B %{startDateTime: "2019-11-21 18:52:29.360", location: "58.379875,26.719141"}
  @create_attrs_zone_A %{startDateTime: "2019-11-21 18:52:29.360", location: "58.382031,26.724258"}# 58.376276,26.722308
  @create_attrs_parking %{startDateTime: "2019-11-21 18:52:29.360", location: "58.382548,26.709504"}
  @create_attrs_finished %{startDateTime: "2019-11-21 18:52:29.360", endDateTime: "2019-11-21 15:52:29.360", location: "58.377201,26.688620"}
  @update_attrs %{endDateTime: "2019-11-22 18:52:29.360"}

  def fixture(:booking) do
    BookingManager.create_booking(1, @create_attrs_finished)
    {:ok, booking} = BookingManager.create_booking(1, @create_attrs_parking)
    booking
  end

  setup %{conn: conn} do
    {_, jwt, _} = UserManager.token_sign_in("ivan","123");
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all bookings", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index))
      assert json_response(conn, 200)["bookings"] == []
    end
  end

  describe "actual" do
    setup [:create_booking]

    test "lists all bookings without endDateTime", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :actual))
      assert [
        %{
          "endDateTime" => nil,
          "location" => "58.382548,26.709504",
          "startDateTime" => "2019-11-21T18:52:29Z"
        }
      ] = json_response(conn, 200)["bookings"]
    end
  end

  describe "create booking" do
    test "booking in parking", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_parking)
      assert %{
        "endDateTime" => nil,
        "hourPayment" => 0,
        "location" => "58.382548,26.709504",
        "positionType" => "parking",
        "realTimePayment" => 0,
        "startDateTime" => "2019-11-21 18:52:29.360"
      } = json_response(conn, 200)
    end

    test "booking on a street zone A", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_zone_A)
      assert %{
        "endDateTime" => nil,
        "hourPayment" => 0,
        "location" => "58.382031,26.724258",
        "positionType" => "outOfPaidZone",
        "realTimePayment" => 0,
        "startDateTime" => "2019-11-21T18:52:29Z"
      } = json_response(conn, 200)
    end

    test "booking on a street zone B", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_zone_B)
      assert %{
        "endDateTime" => nil,
        "hourPayment" => 0,
        "location" => "58.379875,26.719141",
        "positionType" => "outOfPaidZone",
        "realTimePayment" => 0,
        "startDateTime" => "2019-11-21T18:52:29Z"
      } = json_response(conn, 200)
    end

    test "out of paid zone", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_out_of_paid_zone)
      assert %{
        "endDateTime" => nil,
        "hourPayment" => 0,
        "location" => "58.377201,26.688620",
        "positionType" => "outOfPaidZone",
        "realTimePayment" => 0,
        "startDateTime" => "2019-11-21T18:52:29Z"
      } = json_response(conn, 200)
    end
  end

  describe "update booking" do
    setup [:create_booking]

    test "renders parking when data is valid", %{conn: conn, booking: %Booking{id: id}} do
      conn = put(conn, Routes.booking_path(conn, :update, id), booking: @update_attrs)
      assert %{
        "endDateTime" => "2019-11-22T18:52:29Z",
        "location" => "58.382548,26.709504",
        "startDateTime" => "2019-11-21T18:52:29Z"
      } = json_response(conn, 200)
    end
  end

  describe "delete booking" do
    setup [:create_booking]

    test "deletes chosen booking", %{conn: conn, booking: booking} do
      conn = delete(conn, Routes.booking_path(conn, :delete, booking))
      assert response(conn, 204)
    end
  end

  defp create_booking(_) do
    booking = fixture(:booking)
    {:ok, booking: booking}
  end


end
