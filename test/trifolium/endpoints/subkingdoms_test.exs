defmodule Trifolium.SubkingdomsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Subkingdoms
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/subkingdoms/"
    @success_resp %{
      "data" => [
        %{
          "id" => 1,
          "kingdom" => %{
            "id" => 1,
            "links" => %{"self" => "/api/v1/kingdoms/1"},
            "name" => "Plantae",
            "slug" => nil
          },
          "links" => %{
            "kingdom" => "/api/v1/kingdoms/1",
            "self" => "/api/v1/subkingdoms/tracheobionta"
          },
          "name" => "Tracheobionta",
          "slug" => "tracheobionta"
        }
      ],
      "links" => %{
        "first" => "/api/v1/subkingdoms?page=1",
        "last" => "/api/v1/subkingdoms?page=1",
        "self" => "/api/v1/subkingdoms"
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

      assert {:ok, @success_resp} == Subkingdoms.all()
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

      assert {:ok, @success_resp} == Subkingdoms.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Subkingdoms.all()
    end
  end

  describe "find" do
    @id 1
    @path "https://trefle.io/api/v1/subkingdoms/#{@id}"
    @success_resp %{
      "data" => %{
        "id" => @id,
        "kingdom" => %{
          "id" => 1,
          "links" => %{"self" => "/api/v1/kingdoms/1"},
          "name" => "Plantae",
          "slug" => nil
        },
        "links" => %{
          "kingdom" => "/api/v1/kingdoms/1",
          "self" => "/api/v1/subkingdoms/tracheobionta"
        },
        "name" => "Tracheobionta",
        "slug" => "tracheobionta"
      },
      "meta" => %{"last_modified" => "2018-12-30T15:26:43.432Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Subkingdoms.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Subkingdoms.find(@id)
    end
  end
end
