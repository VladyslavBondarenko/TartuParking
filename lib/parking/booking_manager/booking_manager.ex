defmodule Parking.BookingManager do

  import Ecto.Query, warn: false
  alias Parking.{Repo, Booking, ZoneManager}

  def list_bookings do
    Repo.all(Booking) |> Repo.preload([:zone])
  end

  def list_user_bookings(user_id) do
    (from b in Booking, where: b.user_id == ^user_id) |> Repo.all |> Repo.preload([:zone])
  end

  @spec get_booking!(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_booking!(id), do: Repo.get!(Booking, id) |> Repo.preload([:zone])

  def get_actual(user_id) do
    (from b in Booking, where: b.user_id == ^user_id and is_nil(b.endDateTime)) |> Repo.all |> Repo.preload([:zone])
  end

  def create_booking(user_id, zone_id, attrs \\ %{}) do
    cost = calcCost(attrs["startDateTime"], attrs["endDateTime"], attrs["type"], zone_id)
    %Booking{user_id: user_id, zone_id: zone_id, cost: cost}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    cost = calcCost(to_string(booking.startDateTime), attrs["endDateTime"], booking.type, booking.zone_id)
    booking
    |> Booking.changeset(%{cost: cost})
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  defp calcCost(start, finish, type, zone_id) do
    if (!is_nil(finish)) do
      zone = ZoneManager.get_zone!(zone_id)
      {_,start,_} = DateTime.from_iso8601(start)
      {_,finish,_} = DateTime.from_iso8601(finish)
      payMin = DateTime.diff(finish, start) / 60 - zone.freeFirstMinutes
      case payMin do
        x when x > 0 ->
          case type do
            "hourly" -> zone.hourPayment * x / 60
            "realtime" -> zone.realTimePayment * x / 5
            _ -> 0
          end
        _ -> 0
      end
    else
      nil
    end
  end

end
