defmodule Trifolium.FamiliesTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Families
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/families/"
    @success_resp %{
      "data" => [
        %{
          "common_name" => "Acanthus family",
          "division_order" => %{
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
            "id" => 14,
            "links" => %{
              "division_class" => "/api/v1/division_classes/magnoliopsida",
              "self" => "/api/v1/division_orders/scrophulariales"
            },
            "name" => "Scrophulariales",
            "slug" => "scrophulariales"
          },
          "id" => 16,
          "links" => %{
            "division_order" => "/api/v1/division_orders/scrophulariales",
            "genus" => "/api/v1/families/acanthaceae/genus",
            "self" => "/api/v1/families/acanthaceae"
          },
          "name" => "Acanthaceae",
          "slug" => "acanthaceae"
        },
        %{
          "common_name" => "Maple family",
          "division_order" => %{
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
            "id" => 17,
            "links" => %{
              "division_class" => "/api/v1/division_classes/magnoliopsida",
              "self" => "/api/v1/division_orders/sapindales"
            },
            "name" => "Sapindales",
            "slug" => "sapindales"
          },
          "id" => 19,
          "links" => %{
            "division_order" => "/api/v1/division_orders/sapindales",
            "genus" => "/api/v1/families/aceraceae/genus",
            "self" => "/api/v1/families/aceraceae"
          },
          "name" => "Aceraceae",
          "slug" => "aceraceae"
        }
      ],
      "links" => %{
        "first" => "/api/v1/families?page=1",
        "last" => "/api/v1/families?page=34",
        "next" => "/api/v1/families?page=2",
        "self" => "/api/v1/families"
      },
      "meta" => %{"total" => 665}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Families.all()
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

      assert {:ok, @success_resp} == Families.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Families.all()
    end
  end

  describe "find" do
    @id 15
    @path "https://trefle.io/api/v1/families/#{@id}"
    @success_resp %{
      "data" => %{
        "common_name" => "Mint family",
        "division_order" => %{
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
          "id" => 13,
          "links" => %{
            "division_class" => "/api/v1/division_classes/magnoliopsida",
            "self" => "/api/v1/division_orders/lamiales"
          },
          "name" => "Lamiales",
          "slug" => "lamiales"
        },
        "id" => @id,
        "links" => %{
          "division_order" => "/api/v1/division_orders/lamiales",
          "genus" => "/api/v1/families/lamiaceae/genus",
          "self" => "/api/v1/families/lamiaceae"
        },
        "name" => "Lamiaceae",
        "slug" => "lamiaceae"
      },
      "meta" => %{"last_modified" => "2018-12-30T15:28:09.094Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Families.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Families.find(@id)
    end
  end
end
