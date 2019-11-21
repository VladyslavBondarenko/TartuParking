defmodule Parking.ParkingManager.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parkings" do
    field :location, :string
    field :timelimit, :integer, default: 0
    field :area, :string
    field :capacity, :integer, default: 20

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:location, :timelimit, :area, :capacity])
    |> validate_required([:location, :area])
    |> unique_constraint(:location)
  end
end
