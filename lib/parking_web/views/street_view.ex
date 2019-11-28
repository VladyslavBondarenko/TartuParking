defmodule ParkingWeb.StreetView do
  use ParkingWeb, :view
  alias ParkingWeb.StreetView

  def render("index.json", %{streets: streets}) do
    %{streets: render_many(streets, StreetView, "street.json")}
  end

  def render("street.json", %{street: street}) do
    %{id: street.id,
      name: street.name,
      hourPayment: street.zone.hourPayment,
      realTimePayment: street.zone.realTimePayment,
      freeFirstMinutes: street.zone.freeFirstMinutes}
  end
end
