defmodule Trifolium.Auth do
  @moduledoc """
    Module to be used to interact with Trefle [Auth](https://docs.trefle.io/reference/#tag/Auth) related endpoints.
  """
  alias Trifolium.Config
  alias Trifolium.API

  @endpoint_path "api/auth/"
  @http_client Config.http_client()

  @doc """
    Generates a JWT token for a given `origin`, which can be used in your client side
    code, without exposing your private token. You can also specify a `ip` along a `origin`
    so that it works only from some giving client IP Address.
  """
  @spec token(String.t(), String.t() | nil) :: API.response()
  def token(origin, ip \\ nil) do
    @http_client.post(
      get_path("claim"),
      Jason.encode!(%{origin: origin, ip: ip}),
      %{"Content-Type" => "application/json"},
      params: API.build_query_params()
    )
    |> API.parse_response()
  end

  @spec get_path(String.t()) :: String.t()
  defp get_path(url) do
    Config.base_url() <> @endpoint_path <> url
  end
end
