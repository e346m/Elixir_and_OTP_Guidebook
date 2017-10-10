defmodule ConcuerrorPlayground.Mixfile do
  use Mix.Project

  def project do
    [
      app: :concuerror_playground,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixir_path: elixirc_paths(Mix.env),
      test_pattern: "*_test.ex*",
      warn_test_pattern: nil,
      deps: deps()
    ]
  end
  def application do
    [
      extra_applications: [:logger]
    ]
  end
  defp deps do
    []
  end
  defp elixirc_paths(:prod), do: ["lib", "test/concurrency/*"]
  defp elixirc_paths(:test), do: ["test/concurrency/*"]
  defp elixirc_paths(_), do: ["lib"]
end
