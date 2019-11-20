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

alias Parking.{Repo, UserManager, ParkingManager, Street, Zone}

# seed customers
[%{username: "ivan", password: "123"},
 %{username: "andrey", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

# seed parkings
[%{location: "58.387746,26.696940", timelimit: 0},
 %{location: "58.389229,26.705184", timelimit: 0},
 %{location: "58.382548,26.709504", timelimit: 0},
 %{location: "58.379579,26.708482", timelimit: 0},
 %{location: "58.375073,26.704905", timelimit: 0},
 %{location: "58.373601,26.708788", timelimit: 0},
 %{location: "58.369655,26.714181", timelimit: 0},
 %{location: "58.372646,26.720490", timelimit: 0},
 %{location: "58.370602,26.726183", timelimit: 0},
 %{location: "58.380054,26.731616", timelimit: 0},
 %{location: "58.379745,26.738621", timelimit: 0},
 %{location: "58.378639,26.738794", timelimit: 0},
 %{location: "58.378335,26.738633", timelimit: 0},
 %{location: "58.377931,26.742865", timelimit: 0},
 %{location: "58.378844,26.740198", timelimit: 0},
 %{location: "58.371382,26.715311", timelimit: 120},
 %{location: "58.380832,26.729075", timelimit: 120},
 %{location: "58.379130,26.728010", timelimit: 60},
 %{location: "58.385204,26.722591", timelimit: 0},
 %{location: "58.379515,26.716033", timelimit: 0},
 %{location: "58.382568,26.716274", timelimit: 0},
 %{location: "58.380171,26.721308", timelimit: 0},
 %{location: "58.381113,26.722843", timelimit: 0},
 %{location: "58.381385,26.724239", timelimit: 0},
 %{location: "58.379336,26.726476", timelimit: 0},
 %{location: "58.376916,26.725434", timelimit: 0},
 %{location: "58.379342,26.734488", timelimit: 0},
 %{location: "58.377226,26.735497", timelimit: 0},
 %{location: "58.377209,26.734153", timelimit: 0},
 %{location: "58.375328,26.736195", timelimit: 0}]
|> Enum.map(fn parking_data -> ParkingManager.create_parking(parking_data) end)

# seed zones
zoneP = Repo.insert!(%Zone{name: "pedestrian", hourPayment: 0.0, realTimePayment: 0.0})
zoneA = Repo.insert!(%Zone{name: "A", hourPayment: 1.0, realTimePayment: 0.8})
zoneB = Repo.insert!(%Zone{name: "B", hourPayment: 2.0, realTimePayment: 0.16})

# seed streets
streetsZoneP = [
  %{name: "Raekoja plats"},
  %{name: "Küüni"},
  %{name: "Rüütli"},
  %{name: "Küütri"}
]
streetsZoneA = [
  %{name: "Vabaduse puiestee"},
  %{name: "Kompanii"},
  %{name: "Magasini"},
  %{name: "Jaani"},
  %{name: "Munga"},
  %{name: "Gildi"},
  %{name: "Jakobi"},
  %{name: "Lutsu"},
  %{name: "Karl Ernst von Baeri"},
  %{name: "Lossi"},
  %{name: "Vallikraavi"},
  %{name: "Ülikooli"},
  %{name: "Uueturu"},
  %{name: "Poe"}
]
streetsZoneB = [
  %{name: "Kroonuaia"},
  %{name: "Kloostri"},
  %{name: "Tähtvere"},
  %{name: "Oru"},
  %{name: "Veski"},
  %{name: "Näituse"},
  %{name: "Juhan Liivi"},
  %{name: "Kastani"},
  %{name: "Kooli"},
  %{name: "Anna Haava"},
  %{name: "Vabriku"},
  %{name: "Jaan Tõnissoni"},
  %{name: "Julius Kuperjanovi"},
  %{name: "Tiigi"},
  %{name: "Vaksali"},
  %{name: "Vanemuise"},
  %{name: "Õpetaja"},
  %{name: "Pepleri"},
  %{name: "Akadeemia"},
  %{name: "Wilhelm Struve"},
  %{name: "Võru"},
  %{name: "Väike-Tähe"},
  %{name: "Tahe"},
  %{name: "Riia"},
  %{name: "Lille"},
  %{name: "Päeva"},
  %{name: "Pargi"},
  %{name: "Kalevi"},
  %{name: "Lao"},
  %{name: "Aida"},
  %{name: "Aleksandri"},
  %{name: "Sadama"},
  %{name: "Kaluri"},
  %{name: "Kroonuaia"}
]

streetsZoneP |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneP, :streets, data)) end)
streetsZoneA |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneA, :streets, data)) end)
streetsZoneB |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneB, :streets, data)) end)
