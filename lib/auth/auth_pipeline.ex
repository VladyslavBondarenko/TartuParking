defmodule Parking.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :parking,
    module: Parking.Guardian,
    error_handler: Parking.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
