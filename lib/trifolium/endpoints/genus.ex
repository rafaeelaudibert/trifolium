defmodule Trifolium.Genus do
  @moduledoc """
    Module to be used to interact with Trefle [Genus](https://docs.trefle.io/reference/#tag/Genus) related endpoints.
  """

  alias Trifolium.Config
  alias Trifolium.API

  @endpoint_path "api/v1/genus/"
  @http_client Config.http_client()

  @doc """
    List every possible `Genus`.
    This endpoint IS paginated, using a optional keyword parameter. By default, the page 1 is returned.
  """
  @spec all(page: non_neg_integer(), filter: %{}, order: %{}) :: API.response()
  def all(opts \\ []) do
    @http_client.get(
      get_path(),
      [],
      params: API.build_query_params(opts)
    )
    |> API.parse_response()
  end

  @doc """
    Find a specific `Genus` according to its `id` or `slug`.
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

  @doc """
    Lists all available `Plant`s for a specific `Genus` according to its `id` or `slug`.
    You can paginate this endpoint, and also filter it, as explained on Trefle documentation.
    You can use a `filter` or a `not_filter` like so:

    ```
    iex()> Trifolium.Genus.plants(id, filter: %{year: year})
    ```

    The same applies to the `order` and `range` parameters, where you just need to pass a map to it,
    that it will be correctly parsed to the query parameter.
  """
  @spec plants(
          non_neg_integer() | String.t(),
          filter: map,
          filter_not: map,
          order: map,
          range: map,
          page: non_neg_integer()
        ) :: API.response()
  def plants(id, opts \\ []) do
    @http_client.get(
      get_path("#{id}/plants"),
      [],
      params: API.build_query_params(opts)
    )
    |> API.parse_response()
  end

  @doc """
    Lists all available `Specie`s for a specific `Genus` according to its `id` or `slug`.
    You can paginate this endpoint, and also filter it, as explained on Trefle documentation.
    You can use a `filter` or a `not_filter` like so:

    ```
    iex()> Trifolium.Genus.species(id, filter: %{year: year})
    ```

    The same applies to the `order` and `range` parameters, where you just need to pass a map to it,
    that it will be correctly parsed to the query parameter.
  """
  @spec species(
          non_neg_integer() | String.t(),
          filter: map,
          filter_not: map,
          order: map,
          range: map,
          page: non_neg_integer()
        ) :: API.response()
  def species(id, opts \\ []) do
    @http_client.get(
      get_path("#{id}/species"),
      [],
      params: API.build_query_params(opts)
    )
    |> API.parse_response()
  end

  @spec get_path(String.t()) :: String.t()
  defp get_path(url \\ "") do
    Config.base_url() <> @endpoint_path <> url
  end
end
