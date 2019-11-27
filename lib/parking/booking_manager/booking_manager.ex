defmodule Parking.BookingManager do

  import Ecto.Query, warn: false
  alias Parking.{Repo, Booking}

  def list_bookings do
    Repo.all(Booking) |> Repo.preload([:zone])
  end

  def list_user_bookings(user_id) do
    (from b in Booking, where: b.user_id == ^user_id) |> Repo.all |> Repo.preload([:zone])
  end

  @spec get_booking!(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_booking!(id), do: Repo.get!(Booking, id) |> Repo.preload([:zone])

  def get_actual(user_id), do: Repo.all from b in Booking, where: b.user_id == ^user_id and is_nil(b.endDateTime)

  def create_booking(user_id, zone_id, attrs \\ %{}) do
    %Booking{user_id: user_id, zone_id: zone_id}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

end
