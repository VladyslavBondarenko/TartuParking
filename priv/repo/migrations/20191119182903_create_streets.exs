defmodule Parking.Repo.Migrations.AddStreets do
  use Ecto.Migration

  def change do
    create table(:streets) do
      add :name, :string
      add :zone_id, references(:zones)
      add :capacity, :integer
      add :area, :text
      timestamps()
    end
    create unique_index(:streets, [:name])
  end

end
