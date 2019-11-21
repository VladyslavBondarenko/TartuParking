defmodule Parking.BookingManager do

  import Ecto.Query, warn: false
  alias Parking.{Repo, Booking}

  def list_bookings do
    Repo.all(Booking)
  end

  def get_booking!(id), do: Repo.get!(Booking, id)

  def get_actual(user_id), do: Repo.all from b in Booking, where: b.user_id == ^user_id and is_nil(b.endDateTime)

  def create_booking(user_id, attrs \\ %{}) do
    %Booking{user_id: user_id}
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
