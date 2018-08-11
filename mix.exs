defmodule Gonz.MixProject do
  use Mix.Project

  def project do
    [
      app: :gonz,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      # convert markdown to html
      {:earmark, "~> 1.2"},
      # parse the front matter in the markdowns
      {:yaml_elixir, "~> 2.1"}
    ]
  end
end
