defmodule Trifolium.Species do
  @moduledoc """
    Module to be used to interact with Trefle [Species](https://docs.trefle.io/reference/#tag/Species) related endpoints.
  """

  alias Trifolium.Config
  alias Trifolium.API

  @endpoint_path "api/v1/species/"
  @http_client Config.http_client()

  @doc """
    List every possible `Specie`s.
    This endpoint IS paginated, using a optional keyword parameter. By default, the page 1 is returned.
    You can use a `filter` or a `not_filter` like so:

    ```
    iex()> Trifolium.Species.all(filter: %{year: year})
    ```

    The same applies to the `order` and `range` parameters, where you just need to pass a map to it,
    that it will be correctly parsed to the query parameter.
  """
  @spec all(
          filter: map,
          filter_not: map,
          order: map,
          page: non_neg_integer(),
          range: map
        ) :: API.response()
  def all(opts \\ []) do
    @http_client.get(
      get_path(),
      [],
      params: API.build_query_params(opts)
    )
    |> API.parse_response()
  end

  @doc """
    Find a specific `Specie` according to its `id` or `slug`.
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
    Similar to `Trifolium.Species.all`, but you can pass an additional `query` parameter which will full-text search
    for it in the available fields. More information can be found on Trefle documentation.
    This endpoint IS paginated, using a optional keyword parameter. By default, the page 1 is returned.
    You can use a `filter` or a `not_filter` like so:

    ```
    iex()> Trifolium.Species.search(query, filter: %{year: year})
    ```

    The same applies to the `order` and `range` parameters, where you just need to pass a map to it,
    that it will be correctly parsed to the query parameter.
  """
  @spec search(
          String.t(),
          filter: map,
          filter_not: map,
          order: map,
          page: non_neg_integer(),
          range: map
        ) :: API.response()
  def search(query, opts \\ []) do
    @http_client.get(
      get_path("search"),
      [],
      params: API.build_query_params(Keyword.put(opts, :q, query))
    )
    |> API.parse_response()
  end

  @doc """
    Report a problem with a specific `Specie`. The second parameter is optional, as per Trefle docs,
    but be aware that it doesn't make much sense to report a problem without informing it.
    The `notes` parameter is a `String.t()` explaining the problem.

    ```
    iex()> Trifolium.Species.report(id, "Should have synonim Trifolium")
    ```

    If you want to test this endpoint, without bothering Trefle community, you can use the special notes parameter `"TEST"`:

    ```
    iex()> Trifolium.Species.report(id, "TEST")
    ```

  """
  @spec report(integer(), String.t()) :: API.response()
  def report(id, notes \\ "") do
    @http_client.post(
      get_path("#{id}/report"),
      Jason.encode!(%{notes: notes}),
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
