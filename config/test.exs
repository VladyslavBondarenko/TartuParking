use Mix.Config

# Configure your database
import_config "test.secret.exs"
# contant example /config/test.secret.exs
#
# config :parking, Parking.Repo,
#   username: "postgres",
#   password: "postgres",
#   database: "parking_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
# System.put_env("ROUTES_APP_ID","sY36oPVDGCb5mLxaZtDe")
# System.put_env("ROUTES_APP_CODE","T11Y0-P_aav2ndKVL0mZ4A")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :parking, ParkingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
