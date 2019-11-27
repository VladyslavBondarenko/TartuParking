defmodule Parking.Repo.Migrations.AddZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string
      add :hourPayment, :float
      add :realTimePayment, :float
      add :freeFirstMinutes, :integer

      timestamps()
    end
    create unique_index(:zones, [:name])
  end

end
