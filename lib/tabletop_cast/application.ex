defmodule TabletopCast.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TabletopCast.Repo,
      # Start the Telemetry supervisor
      TabletopCastWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TabletopCast.PubSub},
      # Start the Presence module
      TabletopCastWeb.Presence,
      # Start the Endpoint (http/https)
      TabletopCastWeb.Endpoint
      # Start a worker by calling: TabletopCast.Worker.start_link(arg)
      # {TabletopCast.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TabletopCast.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TabletopCastWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
