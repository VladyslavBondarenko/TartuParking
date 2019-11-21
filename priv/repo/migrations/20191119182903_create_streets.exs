defmodule Parking.Repo.Migrations.AddStreets do
  use Ecto.Migration

  def change do
    create table(:streets) do
      add :name, :string
      add :zone_id, references(:zones)
      timestamps()
    end
    create unique_index(:streets, [:name])
  end

end
