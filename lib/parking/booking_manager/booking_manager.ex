defmodule Parking.BookingManager do

  import Ecto.Query, warn: false
  alias Parking.{Repo, Booking, ZoneManager}

  def list_bookings do
    Repo.all(Booking) |> Repo.preload([:zone])
  end

  def list_user_bookings(user_id) do
    (from b in Booking, where: b.user_id == ^user_id) |> Repo.all |> Repo.preload([:street, :parking, street: :zone, parking: :zone])
  end

  @spec get_booking!(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_booking!(id), do: Repo.get!(Booking, id) |> Repo.preload([:street, :parking, street: :zone, parking: :zone])

  def get_actual(user_id) do
    (from b in Booking, where: b.user_id == ^user_id and is_nil(b.endDateTime)) |> Repo.all |> Repo.preload([:street, :parking, street: :zone, parking: :zone])
  end

  def create_booking(user_id, parkingInfo, attrs \\ %{}) do
    zone = case parkingInfo.parkingItem do
      nil         -> ZoneManager.get_zone_by_name("free")
      parkingItem -> parkingItem.zone
    end
    cost = calcCost(attrs["startDateTime"], attrs["endDateTime"], attrs["type"], zone)
    parking_id = case parkingInfo.parkingType do
      "parking" -> parkingInfo.parkingItem.id
      _         -> nil
    end
    street_id = case parkingInfo.parkingType do
      "street" -> parkingInfo.parkingItem.id
      _        -> nil
    end
    %Booking{user_id: user_id, parkingType: parkingInfo.parkingType, parking_id: parking_id, street_id: street_id, cost: cost}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    zone = case booking.parkingType do
      "parking" -> booking.parking.zone
      "street"  -> booking.street.zone
      _         -> ZoneManager.get_zone_by_name("free")
    end
    cost = calcCost(to_string(booking.startDateTime), attrs["endDateTime"], booking.type, zone)
    booking
    |> Booking.changeset(%{cost: cost})
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  def calcCost(start, finish, type, zone) do
    if (!is_nil(finish)) do
      {_,start,_} = DateTime.from_iso8601(start)
      {_,finish,_} = DateTime.from_iso8601(finish)
      payMin = DateTime.diff(finish, start) / 60 - zone.freeFirstMinutes
      case payMin do
        x when x > 0 ->
          case type do
            "hourly"   -> zone.hourPayment * x / 60
            "realtime" -> zone.realTimePayment * x / 5
            _          -> 0
          end
        _ -> 0
      end
    else
      nil
    end
  end

end
