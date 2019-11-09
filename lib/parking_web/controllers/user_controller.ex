defmodule ParkingWeb.UserController do
  use ParkingWeb, :controller

  alias Parking.UserManager
  alias Parking.UserManager.User

  action_fallback ParkingWeb.FallbackController

  def index(conn, _params) do
    users = UserManager.list_users()
    render(conn, "index.json", users: users)
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case UserManager.token_sign_in(username, password) do
      {:ok, token, _claims} -> render conn, "jwt.json", jwt: token
      _ -> {:error, :unauthorized}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserManager.create_user(user_params),
         {:ok, token, _claims} <- Parking.Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserManager.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserManager.get_user!(id)

    with {:ok, %User{} = user} <- UserManager.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserManager.get_user!(id)

    with {:ok, %User{}} <- UserManager.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
