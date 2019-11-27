defmodule Parking.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :startDateTime, :utc_datetime
    field :endDateTime, :utc_datetime
    field :location, :string
    field :type, :string
    field :cost, :float
    belongs_to :user, Parking.User
    belongs_to :zone, Parking.Zone

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:startDateTime, :endDateTime, :location, :type, :cost])
  end
end
