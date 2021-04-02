defmodule Trifolium.KingdomsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Kingdoms
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/kingdoms/"
    @success_resp %{
      "data" => [
        %{
          "id" => 1,
          "links" => %{"self" => "/api/v1/kingdoms/1"},
          "name" => "Plantae",
          "slug" => nil
        }
      ],
      "links" => %{
        "first" => "/api/v1/kingdoms?page=1",
        "last" => "/api/v1/kingdoms?page=1",
        "self" => "/api/v1/kingdoms"
      },
      "meta" => %{"total" => 1}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Kingdoms.all()
    end

    test "accepts a page parameter" do
      page = 1

      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token, page: ^page}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Kingdoms.all(page: page)
    end

    test "With error, returns correctly" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok,
           %HTTPoison.Response{
             body: %{error: "Unauthorized"} |> Jason.encode!(),
             status_code: 401
           }}
        end
      )

      assert {:error, 401, %{"error" => "Unauthorized"}} == Kingdoms.all()
    end
  end

  describe "find" do
    @id 1
    @path "https://trefle.io/api/v1/kingdoms/#{@id}"
    @success_resp %{
      "data" => %{
        "id" => @id,
        "links" => %{"self" => "/api/v1/kingdoms/1"},
        "name" => "Plantae",
        "slug" => nil
      },
      "meta" => %{"last_modified" => "2018-12-30T15:26:43.383Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Kingdoms.find(@id)
    end

    test "With error, returns correctly" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok,
           %HTTPoison.Response{
             body: %{error: "Unauthorized"} |> Jason.encode!(),
             status_code: 401
           }}
        end
      )

      assert {:error, 401, %{"error" => "Unauthorized"}} == Kingdoms.find(@id)
    end
  end
end
