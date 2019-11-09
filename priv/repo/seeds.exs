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
alias Parking.ParkingManager
alias Parking.Repo

# seed customers
[%{id: 1, username: "ivan", password: "123"},
 %{id: 2, username: "andrey", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

[%{id: 1, location: "58.380042, 26.731644"},
 %{id: 2, location: "58.379753, 26.738627"}]
|> Enum.map(fn parking_data -> ParkingManager.create_parking(parking_data) end)
