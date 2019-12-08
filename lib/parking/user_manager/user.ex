defmodule Parking.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :full_name, :string, default: ""
    field :username, :string
    field :password, :string
    field :money, :float, default: 0.0
    has_many :bookings, Parking.Booking

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :username, :password, :money])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
  end
end
