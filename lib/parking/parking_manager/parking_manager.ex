defmodule Parking.ParkingManager do

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.ParkingManager.Parking

  def list_parkings do
    Repo.all(Parking)
  end

  def get_parking!(id), do: Repo.get!(Parking, id)

  def create_parking(attrs \\ %{}) do
    %Parking{}
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

end
