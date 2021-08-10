defmodule Vbtfriends.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Vbtfriends.Repo,
      # Start the Telemetry supervisor
      VbtfriendsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vbtfriends.PubSub},
      # Start the Endpoint (http/https)
      VbtfriendsWeb.Endpoint
      # Start a worker by calling: Vbtfriends.Worker.start_link(arg)
      # {Vbtfriends.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vbtfriends.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VbtfriendsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
