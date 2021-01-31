defmodule BaggyBackend.Guardian.AuthPipeline do
  @moduledoc "Auth pipeline"

  use Guardian.Plug.Pipeline,
    otp_app: :BaggyBackend,
    module: BaggyBackend.Guardian,
    error_handler: BaggyBackend.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
