defmodule ParkingWeb.BookingControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.{BookingManager, UserManager}

  @create_attrs_out_of_paid_zone %{startDateTime: "2019-11-21 18:52:29.360", location: "58.377201,26.688620", type: "realtime"}
  @create_attrs_zone_B %{startDateTime: "2019-11-21 18:52:29.360", location: "58.376133,26.721973", type: "realtime"}
  @create_attrs_zone_A %{startDateTime: "2019-11-21 18:52:29.360", location: "58.382031,26.724258", type: "realtime"}
  @create_attrs_parking %{startDateTime: "2019-11-21 18:52:29.360", location: "58.382548,26.709504", type: "realtime"}
  @create_attrs_finished %{startDateTime: "2019-11-21 18:52:29.360", endDateTime: "2019-11-21 22:52:29.360", location: "58.377201,26.688620", type: "realtime"}
  @update_attrs %{endDateTime: "2019-11-22T23:52:29Z"}

  def fixture(:booking) do
    BookingManager.create_booking(1, 3, @create_attrs_finished)
    {:ok, booking} = BookingManager.create_booking(1, 3, @create_attrs_parking)
    booking = BookingManager.get_booking!(booking.id)
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
    setup [:create_booking]

    test "lists all bookings", %{conn: conn} do
      conn = get(conn, Routes.booking_path(conn, :index))
      assert [
        %{
          "cost" => nil,
          "endDateTime" => "2019-11-21T22:52:29Z",
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.377201,26.688620",
          "realTimePayment" => 0.0,
          "startDateTime" => "2019-11-21T18:52:29Z",
          "type" => "realtime"
        },
        %{
          "cost" => nil,
          "endDateTime" => nil,
          "freeFirstMinutes" => 0,
          "hourPayment" => 0.0,
          "location" => "58.382548,26.709504",
          "realTimePayment" => 0.0,
          "startDateTime" => "2019-11-21T18:52:29Z",
          "type" => "realtime"
        }
      ] = json_response(conn, 200)["bookings"]
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
        "cost" => nil,
        "endDateTime" => nil,
        "freeFirstMinutes" => 0,
        "hourPayment" => 0.0,
        "location" => "58.382548,26.709504",
        "realTimePayment" => 0.0,
        "startDateTime" => "2019-11-21T18:52:29Z",
        "type" => "realtime"
      } = json_response(conn, 200)
    end

    test "booking on a street zone A", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_zone_A)
      assert %{
        "cost" => nil,
        "endDateTime" => nil,
        "freeFirstMinutes" => 0,
        "hourPayment" => 2.0,
        "location" => "58.382031,26.724258",
        "realTimePayment" => 0.16,
        "startDateTime" => "2019-11-21T18:52:29Z",
        "type" => "realtime"
      } = json_response(conn, 200)
    end

    test "booking on a street zone B", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_zone_B)
      assert %{
        "cost" => nil,
        "endDateTime" => nil,
        "freeFirstMinutes" => 0,
        "hourPayment" => 1.0,
        "location" => "58.376133,26.721973",
        "realTimePayment" => 0.08,
        "startDateTime" => "2019-11-21T18:52:29Z",
        "type" => "realtime"
      } = json_response(conn, 200)
    end

    test "out of paid zone", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), booking: @create_attrs_out_of_paid_zone)
      assert %{
        "cost" => nil,
        "endDateTime" => nil,
        "freeFirstMinutes" => 0,
        "hourPayment" => 0.0,
        "location" => "58.377201,26.688620",
        "realTimePayment" => 0.0,
        "startDateTime" => "2019-11-21T18:52:29Z",
        "type" => "realtime"
      } = json_response(conn, 200)
    end
  end

  describe "update booking" do
    setup [:create_booking]

    test "renders parking when data is valid", %{conn: conn} do
      {:ok, booking} = BookingManager.create_booking(1, 1, @create_attrs_zone_A)
      conn = put(conn, Routes.booking_path(conn, :update, booking.id), booking: @update_attrs)
      assert %{ "endDateTime" => "2019-11-22T23:52:29Z" } = json_response(conn, 200)
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
