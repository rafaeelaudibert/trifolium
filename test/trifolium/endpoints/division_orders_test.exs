defmodule Trifolium.DivisionOrdersTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.DivisionOrders
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/division_orders/"
    @success_resp %{
      "data" => [
        %{
          "division_class" => %{
            "division" => %{
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
            "id" => 1,
            "links" => %{
              "division" => "/api/v1/divisions/magnoliophyta",
              "self" => "/api/v1/division_classes/magnoliopsida"
            },
            "name" => "Magnoliopsida",
            "slug" => "magnoliopsida"
          },
          "id" => 1,
          "links" => %{
            "division_class" => "/api/v1/division_classes/magnoliopsida",
            "self" => "/api/v1/division_orders/dipsacales"
          },
          "name" => "Dipsacales",
          "slug" => "dipsacales"
        },
        %{
          "division_class" => %{
            "division" => %{
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
            "id" => 1,
            "links" => %{
              "division" => "/api/v1/divisions/magnoliophyta",
              "self" => "/api/v1/division_classes/magnoliopsida"
            },
            "name" => "Magnoliopsida",
            "slug" => "magnoliopsida"
          },
          "id" => 2,
          "links" => %{
            "division_class" => "/api/v1/division_classes/magnoliopsida",
            "self" => "/api/v1/division_orders/malvales"
          },
          "name" => "Malvales",
          "slug" => "malvales"
        }
      ],
      "links" => %{
        "first" => "/api/v1/division_orders?page=1",
        "last" => "/api/v1/division_orders?page=8",
        "next" => "/api/v1/division_orders?page=2",
        "self" => "/api/v1/division_orders"
      },
      "meta" => %{"total" => 157}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == DivisionOrders.all()
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

      assert {:ok, @success_resp} == DivisionOrders.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == DivisionOrders.all()
    end
  end

  describe "find" do
    @id 1
    @path "https://trefle.io/api/v1/division_orders/#{@id}"
    @success_resp %{
      "data" => %{
        "division_class" => %{
          "division" => %{
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
          "id" => 1,
          "links" => %{
            "division" => "/api/v1/divisions/magnoliophyta",
            "self" => "/api/v1/division_classes/magnoliopsida"
          },
          "name" => "Magnoliopsida",
          "slug" => "magnoliopsida"
        },
        "id" => 1,
        "links" => %{
          "division_class" => "/api/v1/division_classes/magnoliopsida",
          "self" => "/api/v1/division_orders/dipsacales"
        },
        "name" => "Dipsacales",
        "slug" => "dipsacales"
      },
      "meta" => %{"last_modified" => "2018-12-30T15:26:43.570Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == DivisionOrders.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == DivisionOrders.find(@id)
    end
  end
end
