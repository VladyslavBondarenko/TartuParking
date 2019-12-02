defmodule Parking.BookingManagerTest do
  use Parking.DataCase
  alias Parking.{BookingManager, Booking, Parking, Street, Zone}

  @valid_attrs2 %{startDateTime: "2019-11-18T18:52:29Z", location: "58.379979,26.719670", type: "realtime"}
  @valid_attrs3 %{startDateTime: "2019-11-18T18:52:29Z", location: "58.375250,26.719972", type: "realtime"}
  @valid_attrs %{startDateTime: "2019-11-21T18:52:29Z", location: "58.387746,26.696940", type: "hourly"}
  @update_attrs %{"endDateTime" => "2019-11-18T22:52:29Z"}

  def booking_fixture() do
    {:ok, booking} = %Booking{user_id: 1, parkingType: "street", parking_id: nil, street_id: 1}
    |> Booking.changeset(@valid_attrs2)
    |> Repo.insert()
    booking = Repo.get!(Booking, booking.id) |> Repo.preload([:street, :parking, street: :zone, parking: :zone])
    booking
  end

  describe "bookings" do
    test "list_bookings/0 returns all bookings" do
      assert [] = BookingManager.list_bookings()
    end

    test "get_booking!/1 returns the booking with given id" do
      booking = booking_fixture()
      assert BookingManager.get_booking!(booking.id) == booking
    end

    test "create_booking/1 with valid data creates a booking (parking)" do
      user_id = 1
      parkingInfo = %{ parkingType: "parking", parkingItem: Repo.get!(Parking, 1) |> Repo.preload([:zone]) }
      assert {:ok, %Booking{} = booking} = BookingManager.create_booking(user_id, parkingInfo, @valid_attrs)
      assert %Booking{
        cost: nil,
        endDateTime: nil,
        startDateTime: ~U[2019-11-21 18:52:29Z],
        location: "58.387746,26.696940",
        parkingType: "parking",
        parking_id: 1,
        street_id: nil,
        type: "hourly",
        user_id: 1
      } = booking
    end

    test "create_booking/1 with valid data creates a booking (street)" do
      user_id = 1
      parkingInfo = %{ parkingType: "street", parkingItem: Repo.get!(Street, 3) |> Repo.preload([:zone]) }
      assert {:ok, %Booking{} = booking} = BookingManager.create_booking(user_id, parkingInfo, @valid_attrs3)
      assert %Booking{
        cost: nil,
        endDateTime: nil,
        startDateTime: ~U[2019-11-18 18:52:29Z],
        location: "58.375250,26.719972",
        parkingType: "street",
        parking_id: nil,
        street_id: 3,
        type: "realtime",
        user_id: 1
      } = booking
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{} = booking} = BookingManager.update_booking(booking, @update_attrs)
      assert %Booking{
        cost: 7.68,
        endDateTime: ~U[2019-11-18 22:52:29Z],
        location: "58.379979,26.719670",
        parking: nil,
        parkingType: "street",
        parking_id: nil,
        startDateTime: ~U[2019-11-18 18:52:29Z],
        street_id: 1,
        type: "realtime",
        user_id: 1
      } = booking
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = BookingManager.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> BookingManager.get_booking!(booking.id) end
    end

    test "calcCost/4 hourly for zone A" do
      zone = Repo.get!(Zone, 1)
      assert 8.0 = BookingManager.calcCost("2019-11-21T18:52:29.360Z", "2019-11-21T22:52:29.360Z", "hourly", zone)
    end

    test "calcCost/4 realtime for zone A" do
      zone = Repo.get!(Zone, 1)
      assert 7.68 = BookingManager.calcCost("2019-11-21T18:52:29.360Z", "2019-11-21T22:52:29.360Z", "realtime", zone)
    end

    test "calcCost/4 hourly for zone B" do
      zone = Repo.get!(Zone, 2)
      assert 4.0 = BookingManager.calcCost("2019-11-21T18:52:29.360Z", "2019-11-21T22:52:29.360Z", "hourly", zone)
    end

    test "calcCost/4 realtime for zone B" do
      zone = Repo.get!(Zone, 2)
      assert 3.84 = BookingManager.calcCost("2019-11-21T18:52:29.360Z", "2019-11-21T22:52:29.360Z", "realtime", zone)
    end
  end
end
