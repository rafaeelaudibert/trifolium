defmodule Trifolium.DivisionClassesTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.DivisionClasses
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/division_classes/"
    @success_resp %{
      "data" => [
        %{
          "id" => 1,
          "name" => "Magnoliopsida",
          "slug" => "magnoliopsida",
          "links" => %{
            "self" => "/api/v1/division_classes/magnoliopsida",
            "division" => "/api/v1/divisions/magnoliophyta"
          },
          "division" => %{
            "id" => 1,
            "name" => "Magnoliophyta",
            "slug" => "magnoliophyta",
            "links" => %{
              "self" => "/api/v1/divisions/magnoliophyta",
              "subkingdom" => "/api/v1/subkingdoms/tracheobionta"
            },
            "subkingdom" => %{
              "id" => 1,
              "name" => "Tracheobionta",
              "slug" => "tracheobionta",
              "links" => %{
                "self" => "/api/v1/subkingdoms/tracheobionta",
                "kingdom" => "/api/v1/kingdoms/plantae"
              },
              "kingdom" => %{
                "id" => 1,
                "name" => "Plantae",
                "slug" => "plantae",
                "links" => %{
                  "self" => "/api/v1/kingdoms/plantae"
                }
              }
            }
          }
        },
        %{
          "id" => 2,
          "name" => "Pinopsida",
          "slug" => "pinopsida",
          "links" => %{
            "self" => "/api/v1/division_classes/pinopsida",
            "division" => "/api/v1/divisions/coniferophyta"
          },
          "division" => %{
            "id" => 2,
            "name" => "Coniferophyta",
            "slug" => "coniferophyta",
            "links" => %{
              "self" => "/api/v1/divisions/coniferophyta",
              "subkingdom" => "/api/v1/subkingdoms/tracheobionta"
            },
            "subkingdom" => %{
              "id" => 1,
              "name" => "Tracheobionta",
              "slug" => "tracheobionta",
              "links" => %{
                "self" => "/api/v1/subkingdoms/tracheobionta",
                "kingdom" => "/api/v1/kingdoms/plantae"
              },
              "kingdom" => %{
                "id" => 1,
                "name" => "Plantae",
                "slug" => "plantae",
                "links" => %{
                  "self" => "/api/v1/kingdoms/plantae"
                }
              }
            }
          }
        }
      ],
      "links" => %{
        "self" => "/api/v1/division_classes",
        "first" => "/api/v1/division_classes?page=1",
        "last" => "/api/v1/division_classes?page=1"
      },
      "meta" => %{
        "total" => 10
      }
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == DivisionClasses.all()
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

      assert {:ok, @success_resp} == DivisionClasses.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == DivisionClasses.all()
    end
  end

  describe "find" do
    @id 355
    @path "https://trefle.io/api/v1/division_classes/#{@id}"
    @success_resp %{
      "data" => %{
        "division" => nil,
        "id" => 5,
        "links" => %{
          "division" => nil,
          "self" => "/api/v1/division_classes/uncertain-ascomycota-class"
        },
        "name" => "Uncertain Ascomycota Class",
        "slug" => "uncertain-ascomycota-class"
      },
      "meta" => %{"last_modified" => "2018-12-30T15:27:04.601Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == DivisionClasses.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == DivisionClasses.find(@id)
    end
  end
end
