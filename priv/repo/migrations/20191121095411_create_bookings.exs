defmodule Parking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :startDateTime, :timestamp
      add :endDateTime, :timestamp
      add :location, :string
      add :user_id, references(:users)
      add :zone_id, references(:zones)

      timestamps()
    end
  end

end
