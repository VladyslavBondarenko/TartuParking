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

alias Parking.{Repo, UserManager, Zone}

# seed customers
[%{id: 1, username: "ivan", password: "123"}]
|> Enum.map(fn user_data -> UserManager.create_user(user_data) end)

# seed zones
zoneA = Repo.insert!(%Zone{name: "A", hourPayment: 2.0, realTimePayment: 0.16, freeFirstMinutes: 0})
zoneB = Repo.insert!(%Zone{name: "B", hourPayment: 1.0, realTimePayment: 0.08, freeFirstMinutes: 0})
zoneF = Repo.insert!(%Zone{name: "free", hourPayment: 0.0, realTimePayment: 0.0, freeFirstMinutes: 0})

# seed parkings
[%{capacity:  20, location: "58.387746,26.696940", timelimit: 0, area: "58.38811045707349,26.697406020617336 58.38760994822571,26.696209755396694 58.387022263039675,26.69730409667477 58.387601512622474,26.698371615862698"},
 %{capacity:  20, location: "58.379579,26.708482", timelimit: 0, area: "58.37976392189816,26.70835325396729 58.379589546902395,26.70809576190186 58.37939829591593,26.70855710185242 58.379592359409166,26.70881995833588"},
 %{capacity:  20, location: "58.382548,26.709504", timelimit: 0, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"},
 %{capacity:  20, location: "58.378390,26.738600", timelimit: 0, area: "58.37843010866203,26.738337120747474 58.37807571936761,26.73843904469004 58.37845260944946,26.739291987156776"}, #nearest_by_path in test
 %{capacity:  20, location: "58.375391,26.736067", timelimit: 0, area: "58.37555082370519,26.73658919121317 58.375221721192396,26.73431467796854 58.374642268281995,26.735285637631932 58.375221721192396,26.736685750737706"} #nearest_by_distance in test
] |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneF, :parkings, data)) end)

# seed streets
streetsZoneA = [
 %{name: "Lossi", capacity: 20},
 %{name: "Vabaduse puiestee", capacity: 60}
]
streetsZoneB = [
 %{name: "Vanemuise", capacity:  100},
]

streetsZoneA |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneA, :streets, data)) end)
streetsZoneB |> Enum.map(fn data -> Repo.insert!(Ecto.build_assoc(zoneB, :streets, data)) end)
