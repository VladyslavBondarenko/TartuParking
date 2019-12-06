defmodule Parking.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :hourPayment, :float
    field :realTimePayment, :float
    field :freeFirstMinutes, :integer
    has_many :parkings, Parking.Parking
    has_many :streets, Parking.Street

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :hourPayment, :realTimePayment, :freeFirstMinutes])
    |> validate_required([:name, :hourPayment, :realTimePayment, :freeFirstMinutes])
    |> unique_constraint(:name)
  end
end
