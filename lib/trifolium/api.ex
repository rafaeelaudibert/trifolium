defmodule Trifolium.API do
  @moduledoc """
    Thin helper functions to enhance requests to Trefle API.
  """

  @type response :: {:ok, %{}} | {:error, non_neg_integer(), %{}}

  @doc """
  Builds a query params map, which contains the token
  used to communicate with Trefle API, along with
  the keywords which should be passed to Trefle API.
  Accepts a nested map, which in this case will build the parameters
  according to the nested rules allowed on Trefle API.
  Also accepts a list as a possible parameter, stringifying it.
  """
  @spec build_query_params(any) :: %{:token => binary, optional(any) => any}
  def build_query_params(query_opts \\ []) do
    parse_query_opts(query_opts)
    |> Map.merge(token_query_params())
  end

  @spec token_query_params() :: %{token: String.t()}
  defp token_query_params, do: %{token: Trifolium.Config.token()}

  defp parse_query_opts(query_opts) do
    Enum.flat_map(query_opts, fn
      {key, value} when is_list(value) ->
        [{key, Enum.join(value, ",")}]

      {key, value} when is_map(value) ->
        parse_query_opts(value)
        |> Enum.map(fn {inner_key, value} -> {"#{key}[#{inner_key}]", value} end)

      {key, value} ->
        [{key, value}]
    end)
    |> Map.new()
  end

  @doc """
    Parse a response returned by Trefle API in a JSON,
    in a correct fashion, according to the status_code returned

    If the `status_code` field from the request is 200 or 201, returns `{:ok, %{}}`.
    If the `status_code` field from the request is 404, returns `{:error, 404, %{message: message}`
    where `message` is the returned value from Trefle.
    If any status other than 200 or 404 is returned on `status_code`
    we return `{:error, status, message}` where :status is the `status_code` returned, and you
    hould handle the error yourself. The `message` part of the tuple is the `body`
    returned by the request.
  """
  @spec parse_response({:ok, map()}) :: Trifolium.API.response()
  def parse_response({:ok, %{status_code: 200, body: body}}), do: {:ok, Jason.decode!(body)}

  def parse_response({:ok, %{status_code: 201, body: body}}), do: {:ok, Jason.decode!(body)}

  def parse_response({:ok, %{status_code: 404 = status_code, message: message}}),
    do: {:error, status_code, %{message: message}}

  def parse_response({:ok, %{status_code: status_code, body: body}}),
    do: {:error, status_code, Jason.decode!(body)}
end
