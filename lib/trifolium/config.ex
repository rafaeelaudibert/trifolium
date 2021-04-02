# Based on Daniel Berkompas' [ex_twilio](https://github.com/danielberkompas/ex_twilio) library
defmodule Trifolium.Config do
  @moduledoc """
  Stores configuration variables used to communicate with Trefle's API.
  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime.
  """

  @doc """
  Returns Trefle's API token. Set it in `mix.exs`:
      config :trifolium, trefle_token: "YOUR_TREFLE_TOKEN"
  """
  @spec token :: String.t()
  def token, do: from_env(:trifolium, :token)

  @doc """
  Returns the domain of the Trefle API. This will default to "trefle.io/",
  but can be overridden (in case you have a custom Trefle installation)
  using the following setting in `mix.exs`:
      config :trifolium, api_domain: "trefle.yourdomain.com/"
  """
  def api_domain, do: from_env(:trifolium, :api_domain, "trefle.io/")

  @doc """
  Returns the protocol used for the Trefle API. The default is `"https"` for
  interacting with the Trefle API, but when testing with Bypass, you may want
  this to be `"http"`. You can override this in `mix.exs` with:
      config :trifolium, protocol: "http"
  """
  def protocol, do: Application.get_env(:trifolium, :protocol) || "https"

  @doc """
  Return the combined base URL of the Trefle API, using the configuration
  settings given.
  """
  def base_url, do: "#{protocol()}://#{api_domain()}"

  @doc """
    Return the HTTP Client we should use to do this requests. You shouldn't need
    to change this in your app.
  """
  def http_client, do: from_env(:trifolium, :http_client) || HTTPoison

  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples.
  """
  def from_env(otp_app, key, default \\ nil) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
