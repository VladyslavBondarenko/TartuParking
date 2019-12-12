defmodule Parking.UserManager do
  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_money(id, value) do
    user = get_user!(id)
    newValue = user.money + value
    user
    |> User.changeset(%{money: newValue})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def token_sign_in(username, password) do
    case username_password_auth(username, password) do
      {:ok, user} -> {:ok, token, _claims} = Parking.Guardian.encode_and_sign(user)
                     {:ok, token, user}
      _           -> {:error, :unauthorized}
    end
  end

  defp username_password_auth(username, password) do
    with {:ok, user} <- get_by_username(username),
    do: verify_password(password, user)
  end

  defp get_by_username(username) do
    case Repo.one(from u in User, where: u.username == ^username) do
      nil  -> {:error, "Login error"}
      user -> {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) do
    if (password == user.password) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
