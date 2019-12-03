defmodule ParkingWeb.StreetView do
  use ParkingWeb, :view
  alias Parking.StreetManager
  alias ParkingWeb.StreetView

  def render("index.json", %{streets: streets}) do
    %{streets: render_many(streets, StreetView, "street.json")}
  end

  def render("street.json", %{street: street}) do
    %{id: street.id,
      name: street.name,
      capacity: street.capacity,
      hourPayment: street.zone.hourPayment,
      realTimePayment: street.zone.realTimePayment,
      freeFirstMinutes: street.zone.freeFirstMinutes,
      emptySpaces: street.capacity - StreetManager.calc_busy_spaces(street.id),
      area: street.area |> String.split(" ") |> Enum.map(fn e -> e |> String.split(",") |> Enum.reverse() |> Enum.map(fn e -> e |> String.to_float() end) end)
    }
  end
end
