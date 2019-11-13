defmodule Parking.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _}, _otps) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end
