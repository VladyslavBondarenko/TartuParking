defmodule Parking.ParkingManager do

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.{Parking, Booking}

  def list_parkings do
    Repo.all(Parking) |> Repo.preload([:zone])
  end

  def get_parking!(id), do: Repo.get!(Parking, id) |> Repo.preload([:zone])

  def create_parking(attrs \\ %{}) do
    %Parking{zone_id: attrs["zone_id"]}
    |> Parking.changeset(attrs)
    |> Repo.insert()
  end

  def update_parking(%Parking{} = parking, attrs) do
    parking
    |> Parking.changeset(attrs)
    |> Repo.update()
  end

  def delete_parking(%Parking{} = parking) do
    Repo.delete(parking)
  end

  def calc_busy_spaces(parking_id) do
    (from b in Booking, where: b.parking_id == ^parking_id, where: is_nil(b.endDateTime), select: count(b.id)) |> Repo.one
  end

end
