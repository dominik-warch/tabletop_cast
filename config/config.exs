# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tabletop_cast,
  ecto_repos: [TabletopCast.Repo]

# Configures the endpoint
config :tabletop_cast, TabletopCastWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "i5jGG04xQjmLTJ/ZZnMQi50nSwgubySsrpYoZ/hN5D/OOGE1+5VDfyAcCnd718hg",
  render_errors: [view: TabletopCastWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TabletopCast.PubSub,
  live_view: [signing_salt: "i4kPvA/i"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
