defmodule BaggyBackend.AuthErrorHandler do
  @moduledoc "Auth Error Handler"

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end

end
