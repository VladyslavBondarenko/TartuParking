# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Parking.Repo.insert!(%Parking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Parking.UserManager

# seed customers
[%{id: 1, username: "ivan", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)
