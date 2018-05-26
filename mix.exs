defmodule Mets.MixProject do
  use Mix.Project

  def project do
    [
      app: :mets,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Mets.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:con_cache, "~> 0.13.0"}
    ]
  end
end
