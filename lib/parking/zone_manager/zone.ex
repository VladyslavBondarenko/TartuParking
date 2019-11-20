defmodule Parking.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :hourPayment, :float
    field :realTimePayment, :float
    has_many :streets, Parking.Street

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :hourPayment, :realTimePayment])
    |> validate_required([:name, :hourPayment, :realTimePayment])
    |> unique_constraint(:name)
  end
end
