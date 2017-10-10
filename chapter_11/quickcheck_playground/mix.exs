defmodule QuickcheckPlayground.Mixfile do
  use Mix.Project

  def project do
    [
      app: :quickcheck_playground,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      build_embedded: Mix.env == :prod,
      test_pattern: "*_{test, eqc}.exs",
      elixirc_paths: elixirc_path_for_env,
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
      {:eqc_ex, "~> 1.4"}
    ]
  end
  defp elixirc_path_for_env do
    if Mix.env == :test do
      ["lib", "test/support"]
    else
      ["lib"]
    end
  end
end
