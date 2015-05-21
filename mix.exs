defmodule SpheroServer.Mixfile do
  use Mix.Project

  def project do
    [app: :sphero_server,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :sphero, :exactor, :"erlang-serial", :httpoison, :hackney],  mod: {SpheroServer, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
        {:sphero, git: "https://github.com/knewter/sphero.git"},
        {:exrm, "~> 0.15.3"},
        {:poison, "~> 1.4.0"},
        {:httpoison, "~> 0.6.2"}
    ]
  end
end
