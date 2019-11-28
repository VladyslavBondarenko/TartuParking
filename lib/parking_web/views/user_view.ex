defmodule ParkingWeb.UserView do
  use ParkingWeb, :view
  alias ParkingWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      full_name: user.full_name,
      username: user.username}
  end

  def render("sign_up.json", %{user: user}) do
    %{full_name: user["full_name"],
      username: user["username"]}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
