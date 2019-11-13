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

# seed customers
[%{id: 1, username: "ivan", password: "123"},
 %{id: 2, username: "andrey", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

[%{id: 1, location: "58.387746,26.696940", timelimit: 0},
 %{id: 2, location: "58.389229,26.705184", timelimit: 0},
 %{id: 3, location: "58.382548,26.709504", timelimit: 0},
 %{id: 4, location: "58.379579,26.708482", timelimit: 0},
 %{id: 5, location: "58.375073,26.704905", timelimit: 0},
 %{id: 6, location: "58.373601,26.708788", timelimit: 0},
 %{id: 7, location: "58.369655,26.714181", timelimit: 0},
 %{id: 8, location: "58.372646,26.720490", timelimit: 0},
 %{id: 9, location: "58.370602,26.726183", timelimit: 0},
 %{id: 10, location: "58.380054,26.731616", timelimit: 0},
 %{id: 11, location: "58.379745,26.738621", timelimit: 0},
 %{id: 12, location: "58.378639,26.738794", timelimit: 0},
 %{id: 13, location: "58.378335,26.738633", timelimit: 0},
 %{id: 14, location: "58.377931,26.742865", timelimit: 0},
 %{id: 15, location: "58.378844,26.740198", timelimit: 0},
 %{id: 16, location: "58.371382,26.715311", timelimit: 120},
 %{id: 17, location: "58.380832,26.729075", timelimit: 120},
 %{id: 18, location: "58.379130,26.728010", timelimit: 60},
 %{id: 19, location: "58.385204,26.722591", timelimit: 0},
 %{id: 20, location: "58.379515,26.716033", timelimit: 0},
 %{id: 21, location: "58.382568,26.716274", timelimit: 0},
 %{id: 22, location: "58.380171,26.721308", timelimit: 0},
 %{id: 23, location: "58.381113,26.722843", timelimit: 0},
 %{id: 24, location: "58.381385,26.724239", timelimit: 0},
 %{id: 25, location: "58.379336,26.726476", timelimit: 0},
 %{id: 26, location: "58.376916,26.725434", timelimit: 0},
 %{id: 27, location: "58.379342,26.734488", timelimit: 0},
 %{id: 28, location: "58.377226,26.735497", timelimit: 0},
 %{id: 29, location: "58.377209,26.734153", timelimit: 0},
 %{id: 30, location: "58.375328,26.736195", timelimit: 0}]
|> Enum.map(fn parking_data -> ParkingManager.create_parking(parking_data) end)
