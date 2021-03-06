defmodule BaggyBackend.Guardian do
  @moduledoc "Jwt auth module"

  use Guardian, otp_app: :baggy_backend

  # TODO: add pattern matching to ensure error treatment

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = BaggyBackend.Accounts.get_user!(id)
    {:ok, resource}
  end
end
