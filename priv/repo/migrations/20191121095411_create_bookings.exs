defmodule Parking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :startDateTime, :timestamp
      add :endDateTime, :timestamp
      add :location, :string
      add :type, :string
      add :cost, :float
      add :parkingType, :string
      add :parking_id, references(:parkings)
      add :street_id, references(:streets)
      add :user_id, references(:users)

      timestamps()
    end
  end

end
