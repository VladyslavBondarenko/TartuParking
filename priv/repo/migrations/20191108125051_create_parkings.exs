defmodule Parking.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :location, :string
      add :timelimit, :integer

      timestamps()
    end
  end
end
