defmodule Gonz.MixProject do
  use Mix.Project

  def project do
    [
      app: :gonz,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.6"},
      {:earmark, "~> 1.2"}
    ]
  end
end
