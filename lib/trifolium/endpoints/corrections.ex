defmodule Trifolium.Corrections do
  @moduledoc """
    Module to be used to interact with Trefle [Corrections](https://docs.trefle.io/reference/#tag/Corrections) related endpoints.
  """
  alias Trifolium.Config
  alias Trifolium.API

  @endpoint_path "api/v1/corrections/"
  @http_client Config.http_client()

  @doc """
    List every possible `Correction`s.
    This endpoint is NOT paginated, accordingly to Trefle API docs.
  """
  @spec all() :: API.response()
  def all() do
    @http_client.get(
      get_path(),
      [],
      params: API.build_query_params()
    )
    |> API.parse_response()
  end

  @doc """
    Find a specific `Correction`, identified by the `id` parameter.
  """
  @spec find(non_neg_integer()) :: API.response()
  def find(id) do
    @http_client.get(
      get_path("#{id}"),
      [],
      params: API.build_query_params()
    )
    |> API.parse_response()
  end

  @spec report(integer() | String.t(), %{
          notes: String.t() | nil,
          source_type: String.t() | nil,
          source_reference: String.t() | nil,
          correction: %{
            :scientific_name => String.t(),
            optional(any()) => any()
          }
        }) :: API.response()
  def report(id, body) do
    @http_client.post(
      get_path("species/#{id}"),
      Jason.encode!(body),
      [],
      params: API.build_query_params()
    )
    |> API.parse_response()
  end

  @spec get_path(String.t()) :: String.t()
  defp get_path(url \\ "") do
    Config.base_url() <> @endpoint_path <> url
  end
end
