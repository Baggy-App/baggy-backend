defmodule BaggyBackend.Repo do
  use Ecto.Repo,
    otp_app: :baggy_backend,
    adapter: Ecto.Adapters.Postgres
end
