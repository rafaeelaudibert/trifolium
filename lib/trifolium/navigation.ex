defmodule Trifolium.Navigation do
  alias Trifolium.Config
  alias Trifolium.API

  @http_client Config.http_client()

  @doc """
    Given a API returned value, access the `first` result page, according to the
    `links` entry in the API return value.
  """
  @spec first(map) :: API.response()
  def first(%{"links" => %{"first" => _first}} = data), do: navigate("first", data)

  @doc """
    Given a API returned value, access the `last` result page, according to the
    `links` entry in the API return value.
  """
  @spec last(map) :: API.response()
  def last(%{"links" => %{"last" => _lastt}} = data), do: navigate("last", data)

  @doc """
    Given a API returned value, access the `next` result page, according to the
    `links` entry in the API return value.
  """
  @spec next(map) :: API.response()
  def next(%{"links" => %{"next" => _next}} = data), do: navigate("next", data)

  @spec navigate(String.t(), map) :: API.response()
  defp navigate(direction, %{"links" => links}) do
    path = links[direction]

    @http_client.get("#{Config.base_url()}#{path}&token=#{Config.token()}")
    |> API.parse_response()
  end
end
