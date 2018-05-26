defmodule Mets.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Adapters.Cowboy, scheme: :http, plug: Mets.Router, options: [port: 4001]},
      {ConCache, [name: :mets_store, ttl_check_interval: false]}
    ]

    opts = [strategy: :one_for_one, name: Mets.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
