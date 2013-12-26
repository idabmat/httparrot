defmodule Httparrot.Mixfile do
  use Mix.Project

  def project do
    [ app: :httparrot,
      version: "0.0.1",
      name: "HTTParrot",
      elixir: "~> 0.11.2",
      deps: deps(Mix.env) ]
  end

  def application do
    [ applications: [ :compiler,
                      :syntax_tools,
                      :cowboy,
                      :jsex ],
      mod: { HTTParrot, [] },
      env: [ port: 8080 ] ]
  end

  defp deps(:dev) do
    [ {:cowboy, github: "extend/cowboy", tag: "0.9.0" },
      {:jsex, github: "talentdeficit/jsex", ref: "c9df36f07b2089a73ab6b32074c01728f1e5a2e1" } ]
  end

  defp deps(:test) do
    deps(:dev) ++
     [ {:meck, github: "eproxus/meck", tag: "0.8.1" } ]
  end

  defp deps(_), do: deps(:dev)
end
