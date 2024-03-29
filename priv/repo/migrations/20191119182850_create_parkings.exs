defmodule Parking.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :location, :string
      add :timelimit, :integer
      add :area, :text
      add :capacity, :integer
      add :zone_id, references(:zones)

      timestamps()
    end
  end
end
