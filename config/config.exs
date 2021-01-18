# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :baggy_backend,
  ecto_repos: [BaggyBackend.Repo]

# Configures the endpoint
config :baggy_backend, BaggyBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "caXdEnyAn/pKYroSJATlOrKSgp858DihVlAOqTaaYST+vryRHPx+IdW+nIIbwJ7c",
  render_errors: [view: BaggyBackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BaggyBackend.PubSub,
  live_view: [signing_salt: "wnixUkMQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


# Guardian config
config :baggy_backend, BaggyBackend.Guardian,
       issuer: "baggy_backend",
       secret_key: "9vqLQxw3PPalVYDPGPrbeHx/cCEQYa3DFB6zeooHUYqgS1A5sgZ7RwetfKtwM8Rk"
