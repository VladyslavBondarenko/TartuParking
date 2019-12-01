defmodule Parking.Street do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streets" do
    field :name, :string
    field :capacity, :integer, default: 20
    belongs_to :zone, Parking.Zone

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :capacity])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
