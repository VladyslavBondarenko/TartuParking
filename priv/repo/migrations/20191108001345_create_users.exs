defmodule Parking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string
      add :username, :string
      add :password, :string

      timestamps()
    end

    create index("users", [:username], unique: true)
  end
end
