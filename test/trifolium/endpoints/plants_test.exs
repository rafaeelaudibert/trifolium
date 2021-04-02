defmodule Trifolium.PlantsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Plants
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/plants/"
    @success_resp %{
      "data" => [
        %{
          "author" => "Lam.",
          "bibliography" => "Encycl. 1: 723 (1785)",
          "common_name" => "Evergreen oak",
          "family" => "Fagaceae",
          "family_common_name" => "Beech family",
          "genus" => "Quercus",
          "genus_id" => 5778,
          "id" => 678_281,
          "image_url" =>
            "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30",
          "links" => %{
            "genus" => "/api/v1/genus/quercus",
            "plant" => "/api/v1/plants/quercus-rotundifolia",
            "self" => "/api/v1/species/quercus-rotundifolia"
          },
          "rank" => "species",
          "scientific_name" => "Quercus rotundifolia",
          "slug" => "quercus-rotundifolia",
          "status" => "accepted",
          "synonyms" => [
            "Quercus lyauteyi",
            "Quercus rotundifolia f. crassicupulata",
            "Quercus ballota",
            "Quercus ilex f. brevicupulata",
            "Quercus calycina",
            "Quercus rotundifolia f. dolichocalyx",
            "Quercus rotundifolia f. pilosella",
            "Quercus rotundifolia f. macrocarpa",
            "Quercus rotundifolia f. calycina",
            "Quercus ilex f. macrocarpa",
            "Quercus ilex subsp. ballota",
            "Quercus rotundifolia var. pilosella",
            "Quercus rotundifolia var. brevicupulata",
            "Quercus rotundifolia subsp. maghrebiana",
            "Quercus rotundifolia f. brevicupulata",
            "Quercus rotundifolia var. macrocarpa"
          ],
          "year" => 1785
        },
        %{
          "author" => "L.",
          "bibliography" => "Sp. Pl.: 984 (1753)",
          "common_name" => "Stinging nettle",
          "family" => "Urticaceae",
          "family_common_name" => "Nettle family",
          "genus" => "Urtica",
          "genus_id" => 1028,
          "id" => 190_500,
          "image_url" =>
            "https://bs.plantnet.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248",
          "links" => %{
            "genus" => "/api/v1/genus/urtica",
            "plant" => "/api/v1/plants/urtica-dioica",
            "self" => "/api/v1/species/urtica-dioica"
          },
          "rank" => "species",
          "scientific_name" => "Urtica dioica",
          "slug" => "urtica-dioica",
          "status" => "accepted",
          "synonyms" => [
            "Urtica major",
            "Urtica tibetica",
            "Urtica sicula",
            "Urtica eckloniana",
            "Urtica haussknechtii",
            "Urtica submitis"
          ],
          "year" => 1753
        }
      ],
      "links" => %{
        "first" => "/api/v1/plants?page=1",
        "last" => "/api/v1/plants?page=18879",
        "next" => "/api/v1/plants?page=2",
        "self" => "/api/v1/plants"
      },
      "meta" => %{"total" => 377_570}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Plants.all()
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

      assert {:ok, @success_resp} == Plants.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Plants.all()
    end
  end

  describe "find" do
    @id 678_281
    @path "https://trefle.io/api/v1/plants/#{@id}"
    @success_resp %{
      "data" => %{
        "author" => "Lam.",
        "bibliography" => "Encycl. 1: 723 (1785)",
        "common_name" => "Evergreen Oak",
        "family" => %{
          "common_name" => "Beech family",
          "id" => 242,
          "links" => %{
            "division_order" => "/api/v1/division_orders/fagales",
            "genus" => "/api/v1/families/fagaceae/genus",
            "self" => "/api/v1/families/fagaceae"
          },
          "name" => "Fagaceae",
          "slug" => "fagaceae"
        },
        "family_common_name" => "Beech family",
        "forms" => [],
        "genus" => %{
          "id" => 5778,
          "links" => %{
            "family" => "/api/v1/families/fagaceae",
            "plants" => "/api/v1/genus/quercus/plants",
            "self" => "/api/v1/genus/quercus",
            "species" => "/api/v1/genus/quercus/species"
          },
          "name" => "Quercus",
          "slug" => "quercus"
        },
        "genus_id" => 5778,
        "hybrids" => [],
        "id" => 369_441,
        "image_url" => "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30",
        "links" => %{
          "genus" => "/api/v1/genus/quercus",
          "self" => "/api/v1/plants/quercus-rotundifolia",
          "species" => "/api/v1/plants/quercus-rotundifolia/species"
        },
        "main_species" => %{
          "author" => "Lam.",
          "bibliography" => "Encycl. 1: 723 (1785)",
          "common_name" => "Evergreen oak",
          "common_names" => %{
            "en" => ["Evergreen Oak", "Holly oak", "Holm Oak", "Sweet Acorn Oak"],
            "es" => ["Chaparra", "Carrasca"],
            "fr" => ["Chêne vert"]
          },
          "distribution" => %{
            "introduced" => ["Canary Is.", "Madeira"],
            "native" => ["Algeria", "France", "Libya", "Morocco", "Portugal", "Spain", "Tunisia"]
          },
          "distributions" => %{
            "introduced" => [
              %{
                "id" => 124,
                "links" => %{
                  "plants" => "/api/v1/distributions/cny/plants",
                  "self" => "/api/v1/distributions/cny",
                  "species" => "/api/v1/distributions/cny/species"
                },
                "name" => "Canary Is.",
                "slug" => "cny",
                "species_count" => 2360,
                "tdwg_code" => "CNY",
                "tdwg_level" => 3
              }
            ]
          },
          "duration" => nil,
          "edible" => false,
          "edible_part" => nil,
          "family" => "Fagaceae",
          "family_common_name" => "Beech family",
          "flower" => %{"color" => nil, "conspicuous" => nil},
          "foliage" => %{"color" => nil, "leaf_retention" => nil, "texture" => nil},
          "fruit_or_seed" => %{
            "color" => nil,
            "conspicuous" => nil,
            "seed_persistence" => nil,
            "shape" => nil
          },
          "genus" => "Quercus",
          "genus_id" => 5778,
          "growth" => %{
            "atmospheric_humidity" => nil,
            "bloom_months" => nil,
            "days_to_harvest" => nil,
            "description" => nil,
            "fruit_months" => nil
          },
          "id" => 678_281,
          "image_url" =>
            "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30",
          "images" => %{
            "fruit" => [
              %{
                "copyright" => "Taken May 4, 2020 by Manuel Familiar Ramos (cc-by-sa)",
                "id" => 3_371_063,
                "image_url" =>
                  "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30"
              }
            ]
          },
          "links" => %{
            "genus" => "/api/v1/genus/quercus",
            "plant" => "/api/v1/plants/quercus-rotundifolia",
            "self" => "/api/v1/species/quercus-rotundifolia"
          },
          "observations" => "SW. Europe, N. Africa",
          "rank" => "species",
          "scientific_name" => "Quercus rotundifolia",
          "slug" => "quercus-rotundifolia",
          "sources" => [
            %{
              "citation" =>
                "POWO (2019). Plants of the World Online. Facilitated by the Royal Botanic Gardens, Kew. Published on the Internet; http://www.plantsoftheworldonline.org/ Retrieved 2020-06-24",
              "id" => "urn:lsid:ipni.org:names:296696-1",
              "last_update" => "2020-06-24T14:33:16.535Z",
              "name" => "POWO",
              "url" => "http://powo.science.kew.org/taxon/urn:lsid:ipni.org:names:296696-1"
            }
          ],
          "specifications" => %{
            "average_height" => %{"cm" => nil},
            "growth_form" => nil
          },
          "status" => "accepted",
          "synonyms" => [
            %{
              "author" => "Sennen",
              "id" => 325_524,
              "name" => "Quercus lyauteyi",
              "sources" => []
            }
          ],
          "vegetable" => false,
          "year" => 1785
        },
        "main_species_id" => 678_281,
        "observations" => "SW. Europe, N. Africa",
        "scientific_name" => "Quercus rotundifolia",
        "slug" => "quercus-rotundifolia",
        "sources" => [
          %{
            "citation" =>
              "POWO (2019). Plants of the World Online. Facilitated by the Royal Botanic Gardens, Kew. Published on the Internet; http://www.plantsoftheworldonline.org/ Retrieved 2020-06-24",
            "id" => "urn:lsid:ipni.org:names:296696-1",
            "last_update" => "2020-06-24T14:33:16.535Z",
            "name" => "POWO",
            "url" => "http://powo.science.kew.org/taxon/urn:lsid:ipni.org:names:296696-1"
          }
        ],
        "species" => [
          %{
            "author" => "Lam.",
            "bibliography" => "Encycl. 1: 723 (1785)",
            "common_name" => "Evergreen oak",
            "family" => "Fagaceae",
            "family_common_name" => "Beech family",
            "genus" => "Quercus",
            "genus_id" => 5778,
            "id" => 678_281,
            "image_url" =>
              "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30",
            "links" => %{
              "genus" => "/api/v1/genus/quercus",
              "plant" => "/api/v1/plants/quercus-rotundifolia",
              "self" => "/api/v1/species/quercus-rotundifolia"
            },
            "rank" => "species",
            "scientific_name" => "Quercus rotundifolia",
            "slug" => "quercus-rotundifolia",
            "status" => "accepted",
            "synonyms" => ["Quercus lyauteyi"],
            "year" => 1785
          }
        ],
        "subspecies" => [],
        "subvarieties" => [],
        "varieties" => [],
        "vegetable" => false,
        "year" => 1785
      },
      "meta" => %{"last_modified" => "2021-03-04T19:31:12.520Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Plants.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Plants.find(@id)
    end
  end

  describe "search" do
    @query "quercus-rotundifolia"
    @path "https://trefle.io/api/v1/plants/search"
    @success_resp %{
      "data" => [
        %{
          "author" => "Lam.",
          "bibliography" => "Encycl. 1: 723 (1785)",
          "common_name" => "Evergreen oak",
          "family" => "Fagaceae",
          "family_common_name" => "Beech family",
          "genus" => "Quercus",
          "genus_id" => 5778,
          "id" => 678_281,
          "image_url" =>
            "https://bs.plantnet.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30",
          "links" => %{
            "genus" => "/api/v1/genus/quercus",
            "plant" => "/api/v1/plants/quercus-rotundifolia",
            "self" => "/api/v1/species/quercus-rotundifolia"
          },
          "rank" => "species",
          "scientific_name" => "Quercus rotundifolia",
          "slug" => "quercus-rotundifolia",
          "status" => "accepted",
          "synonyms" => ["Quercus lyauteyi"],
          "year" => 1785
        },
        %{
          "author" => "A.DC.",
          "bibliography" => "A.P.de Candolle, Prodr. 16(2): 101 (1864)",
          "common_name" => "Evergreen oak",
          "family" => "Fagaceae",
          "family_common_name" => "Beech family",
          "genus" => "Quercus",
          "genus_id" => 5778,
          "id" => 676_140,
          "image_url" =>
            "https://bs.plantnet.org/image/o/8672546f20f45e759aa30d62e8f148b1884a0ea0",
          "links" => %{
            "genus" => "/api/v1/genus/quercus",
            "plant" => "/api/v1/plants/quercus-helferiana",
            "self" => "/api/v1/species/quercus-helferiana"
          },
          "rank" => "species",
          "scientific_name" => "Quercus helferiana",
          "slug" => "quercus-helferiana",
          "status" => "accepted",
          "synonyms" => ["Quercus ilex"],
          "year" => 1864
        },
        %{
          "author" => "Colmeiro & E.Boutelou",
          "bibliography" => "Exam. Arb. Pen.: 9 (1854)",
          "common_name" => nil,
          "family" => "Fagaceae",
          "family_common_name" => "Beech family",
          "genus" => "Quercus",
          "genus_id" => 5778,
          "id" => 679_162,
          "image_url" => nil,
          "links" => %{
            "genus" => "/api/v1/genus/quercus",
            "plant" => "/api/v1/plants/quercus-x-avellaniformis",
            "self" => "/api/v1/species/quercus-x-avellaniformis"
          },
          "rank" => "hybrid",
          "scientific_name" => "Quercus × avellaniformis",
          "slug" => "quercus-x-avellaniformis",
          "status" => "accepted",
          "synonyms" => ["Quercus rotundifolia f. avellaniformis"],
          "year" => 1854
        }
      ],
      "links" => %{
        "first" => "/api/v1/plants/search?page=1&q=quercus-rotundifolia",
        "last" => "/api/v1/plants/search?page=1&q=quercus-rotundifolia",
        "self" => "/api/v1/plants/search?q=quercus-rotundifolia"
      },
      "meta" => %{"total" => 3}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token, q: @query}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Plants.search(@query)
    end

    test "accepts filters and sends to Trefle API" do
      expect(
        @http_client,
        :get,
        fn @path,
           [],
           [
             params: %{
               :token => @token,
               :q => @query,
               :page => 2,
               "filter[humidity]" => 20,
               "filter_not[year]" => 1714,
               "order[ground_humidity]" => "ASC",
               "range[days_to_harvest]" => "5,10"
             }
           ] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} ==
               Plants.search(
                 @query,
                 page: 2,
                 filter: %{humidity: 20},
                 filter_not: %{year: 1714},
                 order: %{ground_humidity: "ASC"},
                 range: %{days_to_harvest: [5, 10]}
               )
    end

    test "With error, returns correctly" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token, q: @query}] ->
          {:ok,
           %HTTPoison.Response{
             body: %{error: "Unauthorized"} |> Jason.encode!(),
             status_code: 401
           }}
        end
      )

      assert {:error, 401, %{"error" => "Unauthorized"}} == Plants.search(@query)
    end
  end

  describe "report" do
    @id 189_579
    # Even in the remote case that the mock doesn't work, do not create fake report
    @notes "TEST"
    @body Jason.encode!(%{notes: @notes})
    @path "https://trefle.io/api/v1/plants/#{@id}/report"
    @success_resp %{
      "data" => %{
        "accepted_by" => nil,
        "change_status" => "pending",
        "change_type" => "update",
        "changes" => nil,
        "correction" => nil,
        "created_at" => "2021-04-02T01:26:46.084Z",
        "id" => 58291,
        "notes" => nil,
        "record_id" => @id,
        "record_type" => "Species",
        "updated_at" => "2021-04-02T01:26:46.193Z",
        "user_id" => 2,
        "warning_type" => "report"
      },
      "meta" => %{"last_modified" => "2021-04-02T01:26:46.193Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :post,
        fn @path, @body, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Plants.report(@id, @notes)
    end

    test "With error, returns correctly" do
      expect(
        @http_client,
        :post,
        fn @path, @body, [], [params: %{token: @token}] ->
          {:ok,
           %HTTPoison.Response{
             body: %{error: "Unauthorized"} |> Jason.encode!(),
             status_code: 401
           }}
        end
      )

      assert {:error, 401, %{"error" => "Unauthorized"}} == Plants.report(@id, @notes)
    end
  end
end
