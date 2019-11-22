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
[%{id: 1, username: "ivan", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

# seed parkings
[%{location: "58.382548,26.709504", timelimit: 0, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"}]
|> Enum.map(fn parking_data -> ParkingManager.create_parking(parking_data) end)

# seed zones
zoneP = Repo.insert!(%Zone{name: "pedestrian", hourPayment: 0.0, realTimePayment: 0.0})
zoneA = Repo.insert!(%Zone{name: "A", hourPayment: 2.0, realTimePayment: 0.16})
zoneB = Repo.insert!(%Zone{name: "B", hourPayment: 1.0, realTimePayment: 0.08})

# seed streets
streetsZoneA = [
 %{name: "Lossi"},
 %{name: "Vabaduse puiestee"}
]
streetsZoneB = [
 %{name: "Vanemuise"},
]

streetsZoneA |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneA, :streets, data)) end)
streetsZoneB |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneB, :streets, data)) end)
