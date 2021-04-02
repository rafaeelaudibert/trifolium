defmodule Trifolium.DivisionsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Divisions
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/divisions/"
    @success_resp %{
      "data" => [
        %{
          "id" => 1,
          "links" => %{
            "self" => "/api/v1/divisions/magnoliophyta",
            "subkingdom" => "/api/v1/subkingdoms/tracheobionta"
          },
          "name" => "Magnoliophyta",
          "slug" => "magnoliophyta",
          "subkingdom" => %{
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
        },
        %{
          "id" => 2,
          "links" => %{
            "self" => "/api/v1/divisions/coniferophyta",
            "subkingdom" => "/api/v1/subkingdoms/tracheobionta"
          },
          "name" => "Coniferophyta",
          "slug" => "coniferophyta",
          "subkingdom" => %{
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
        }
      ],
      "links" => %{
        "first" => "/api/v1/divisions?page=1",
        "last" => "/api/v1/divisions?page=1",
        "self" => "/api/v1/divisions"
      },
      "meta" => %{"total" => 9}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Divisions.all()
    end

    test "accepts a page parameter" do
      page = 5

      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token, page: ^page}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Divisions.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Divisions.all()
    end
  end

  describe "find" do
    @id 4
    @path "https://trefle.io/api/v1/divisions/#{@id}"
    @success_resp %{
      "data" => %{
        "id" => @id,
        "links" => %{
          "self" => "/api/v1/divisions/cycadophyta",
          "subkingdom" => "/api/v1/subkingdoms/tracheobionta"
        },
        "name" => "Cycadophyta",
        "slug" => "cycadophyta",
        "subkingdom" => %{
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
      },
      "meta" => %{"last_modified" => "2018-12-30T18:08:11.173Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Divisions.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Divisions.find(@id)
    end
  end
end
