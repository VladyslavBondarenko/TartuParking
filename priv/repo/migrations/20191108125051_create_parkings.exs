defmodule Parking.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :location, :string
      add :timelimit, :integer
      add :area, :text

      timestamps()
    end
  end
end
