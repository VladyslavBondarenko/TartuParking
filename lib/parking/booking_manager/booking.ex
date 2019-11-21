defmodule Parking.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :startDateTime, :utc_datetime
    field :endDateTime, :utc_datetime
    field :location, :string
    belongs_to :user, Parking.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:startDateTime, :endDateTime, :location])
  end
end
