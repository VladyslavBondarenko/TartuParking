defmodule Parking.BookingManagerTest do
  use Parking.DataCase
  alias Parking.{BookingManager, Booking}

  @valid_attrs2 %{startDateTime: "2019-11-18T18:52:29.360Z", location: "58.379979,26.719670", type: "realtime"}
  @valid_attrs %{startDateTime: "2019-11-21T18:52:29.360Z", location: "58.375256,26.719984", type: "hourly"}
  @update_attrs %{endDateTime: "2019-11-21T22:52:29.360Z"}

  def booking_fixture() do
    {:ok, booking} = %Booking{user_id: 1, zone_id: 1}
    |> Booking.changeset(@valid_attrs2)
    |> Repo.insert()
    booking = Repo.get!(Booking, booking.id) |> Repo.preload([:zone])
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

    test "create_booking/1 with valid data creates a booking" do
      user_id = 1
      zone_id = 2
      assert {:ok, %Booking{} = booking} = BookingManager.create_booking(user_id, zone_id, @valid_attrs)
      assert booking.location == "58.375256,26.719984"
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{} = booking} = BookingManager.update_booking(booking, @update_attrs)
      assert booking.endDateTime == ~U[2019-11-21 22:52:29Z]
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = BookingManager.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> BookingManager.get_booking!(booking.id) end
    end
  end
end
