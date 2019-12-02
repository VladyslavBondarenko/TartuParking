defmodule Parking.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :startDateTime, :utc_datetime
    field :endDateTime, :utc_datetime
    field :location, :string
    field :type, :string
    field :cost, :float
    field :parkingType, :string
    belongs_to :parking, Parking.Parking
    belongs_to :street, Parking.Street
    belongs_to :user, Parking.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:startDateTime, :endDateTime, :location, :type, :cost, :parkingType])
  end
end
