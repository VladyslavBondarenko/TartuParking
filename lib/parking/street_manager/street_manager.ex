defmodule Parking.StreetManager do

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.{Street, Zone}

  def list_streets do
    Repo.all(Street) |> Repo.preload([:zone])
  end

  def get_street!(id), do: Repo.get!(Street, id) |> Repo.preload([:zone])

  def get_street_zone_info(name) do
    (from s in Street, where: s.name == ^name, join: z in Zone, on: s.zone_id == z.id) |> Repo.one |> Repo.preload([:zone])
  end

  def create_street(attrs \\ %{}) do
    %Street{}
    |> Street.changeset(attrs)
    |> Repo.insert()
  end

  def update_street(%Street{} = street, attrs) do
    street
    |> Street.changeset(attrs)
    |> Repo.update()
  end

  def delete_street(%Street{} = street) do
    Repo.delete(street)
  end

end
