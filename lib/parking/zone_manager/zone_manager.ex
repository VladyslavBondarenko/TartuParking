defmodule Parking.ZoneManager do

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.Zone

  def list_zones do
    Repo.all(Parking)
  end

  def get_zone!(id), do: Repo.get!(Zone, id)

  def get_zone_by_name(name) do
    (from z in Zone, where: z.name == ^name) |> Repo.one
  end

  def create_zone(attrs \\ %{}) do
    %Zone{}
    |> Zone.changeset(attrs)
    |> Repo.insert()
  end

  def update_zone(%Zone{} = zone, attrs) do
    zone
    |> Zone.changeset(attrs)
    |> Repo.update()
  end

  def delete_zone(%Zone{} = zone) do
    Repo.delete(zone)
  end

end
