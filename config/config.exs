# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :real_world,
  ecto_repos: [RealWorld.Repo]

# Configures the endpoint
config :real_world, RealWorldWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Led6DMzyWYDtkgv4F0bHzIKZb2nv4s5P/1iHf1eW0ZdRCUqZSuGMyTJn1qOSYkm4",
  render_errors: [view: RealWorldWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RealWorld.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :real_world, RealWorldWeb.Guardian,
  issuer: "RealWorld",
  secret_key: "MDLMflIpKod5YCnkdiY7C4E3ki2rgcAAMwfBl0+vyC5uqJNgoibfQmAh7J3uZWVK",
  # optional
  allowed_algos: ["HS256"],
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
