# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :parking,
  ecto_repos: [Parking.Repo]

# Configures the endpoint
config :parking, ParkingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RMTVCChnZIlG5Nc6FsyZM8akQejx2puNnvDrpV8kiIXP01AwZXnflQClxbfpeqPg",
  render_errors: [view: ParkingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Parking.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

import_config "auth_config.secret.exs"
# Example guardian config, put it in auth_config.secret.exs

# config :parking, Parking.Guardian,
#   issuer: "parking",
#   secret_key: "hTY/00Y2V5EWlm3P8fj9spnYQ6uoe9UuYALHNuYtvMepN1MzlUkFnPbbIvb3rahv" # generate secret key with `mix guardian.gen.secret`
