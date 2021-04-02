defmodule Trifolium.DivisionClasses do
  @moduledoc """
    Module to be used to interact with Trefle [DivisionClasses](https://docs.trefle.io/reference/#tag/DivisionClasses) related endpoints.
  """

  alias Trifolium.Config
  alias Trifolium.API

  @endpoint_path "api/v1/division_classes/"
  @http_client Config.http_client()

  @doc """
    List every possible `DivisionClass`es.
    This endpoint IS paginated, using a optional keyword parameter. By default, the page 1 is returned.
  """
  @spec all(page: non_neg_integer()) :: API.response()
  def all(opts \\ []) do
    @http_client.get(
      get_path(),
      [],
      params: API.build_query_params(opts)
    )
    |> API.parse_response()
  end

  @doc """
    Find a specific `DivisionClass` according to its `id`.
  """
  @spec find(non_neg_integer() | String.t()) :: API.response()
  def find(id) do
    @http_client.get(
      get_path("#{id}"),
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