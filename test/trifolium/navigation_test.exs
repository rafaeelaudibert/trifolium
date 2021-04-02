defmodule Trifolium.NavigationsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Navigation
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()
  @first_request %{
    "links" => %{
      "first" => "/api/v1/species?page=1",
      "last" => "/api/v1/species?page=20348",
      "next" => "/api/v1/species?page=3",
      "prev" => "/api/v1/species?page=1",
      "self" => "/api/v1/species?page=2"
    }
  }
  @response %{"status" => 200}

  describe "next" do
    @path "#{Config.base_url()}#{@first_request["links"]["next"]}&token=#{@token}"

    test "calls the endpoint with the correct path" do
      expect(
        @http_client,
        :get,
        fn @path ->
          {:ok, %HTTPoison.Response{body: @response |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @response} == Navigation.next(@first_request)
    end
  end

  describe "last" do
    @path "#{Config.base_url()}#{@first_request["links"]["last"]}&token=#{@token}"

    test "calls the endpoint with the correct path" do
      expect(
        @http_client,
        :get,
        fn @path ->
          {:ok, %HTTPoison.Response{body: @response |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @response} == Navigation.last(@first_request)
    end
  end

  describe "first" do
    @path "#{Config.base_url()}#{@first_request["links"]["first"]}&token=#{@token}"

    test "calls the endpoint with the correct path" do
      expect(
        @http_client,
        :get,
        fn @path ->
          {:ok, %HTTPoison.Response{body: @response |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @response} == Navigation.first(@first_request)
    end
  end
end
