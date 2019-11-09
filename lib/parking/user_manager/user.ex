defmodule Parking.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :full_name, :string, default: ""
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
  end
end
