defmodule Parking.ParkingManager.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parkings" do
    field :location, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:location])
    |> validate_required([:location])
    |> unique_constraint(:location)
  end
end
