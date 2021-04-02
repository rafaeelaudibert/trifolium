defmodule Trifolium.MixProject do
  use Mix.Project

  def project,
    do: [
      app: :trifolium,
      version: "1.0.0",
      elixir: "~> 1.11",
      name: "Trifolium",
      description: "Trefle API Library wrapper for Elixir",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]

  # Run "mix help compile.app" to learn about applications.
  def application, do: [extra_applications: [:logger]]

  # Run "mix help deps" to learn about dependencies.
  defp deps,
    do: [
      {:httpoison, "~> 1.8"},
      {:jason, "~>1.2"},
      {:mox, "~> 0.5", only: :test},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]

  defp docs,
    do: [
      readme: "README.md",
      main: Trifolium
    ]

  defp package,
    do: [
      maintainers: ["Rafael Baldasso Audibert"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/rafaeelaudibert/trifolium"}
    ]

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]
end
