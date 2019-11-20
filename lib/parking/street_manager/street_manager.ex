defmodule Parking.StreetManager do

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.Street

  def list_streets do
    Repo.all(Street)
  end

  def get_street!(id), do: Repo.get!(Street, id)

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

  def change_street(%Street{} = street) do
    Street.changeset(street, %{})
  end

end
