defmodule Trifolium.SpeciesTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Species
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/species/"
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
          "synonyms" => ["Urtica major"],
          "year" => 1753
        }
      ],
      "links" => %{
        "first" => "/api/v1/species?page=1",
        "last" => "/api/v1/species?page=20348",
        "next" => "/api/v1/species?page=2",
        "self" => "/api/v1/species"
      },
      "meta" => %{"total" => 406_944}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Species.all()
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

      assert {:ok, @success_resp} == Species.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Species.all()
    end
  end

  describe "find" do
    @id 678_281
    @path "https://trefle.io/api/v1/species/#{@id}"
    @success_resp %{
      "data" => %{
        "author" => "L.",
        "bibliography" => "Sp. Pl.: 984 (1753)",
        "common_name" => "Stinging nettle",
        "common_names" => %{"eo" => ["Urtiko"], "ne" => ["सिस्नो"]},
        "distribution" => %{
          "introduced" => ["Alabama", "Alaska"],
          "native" => ["Afghanistan", "Albania"]
        },
        "distributions" => %{
          "introduced" => [
            %{
              "id" => 144,
              "links" => %{
                "plants" => "/api/v1/distributions/ala/plants",
                "self" => "/api/v1/distributions/ala",
                "species" => "/api/v1/distributions/ala/species"
              },
              "name" => "Alabama",
              "slug" => "ala",
              "species_count" => 3874,
              "tdwg_code" => "ALA",
              "tdwg_level" => 3
            },
            %{
              "id" => 325,
              "links" => %{
                "plants" => "/api/v1/distributions/ask/plants",
                "self" => "/api/v1/distributions/ask",
                "species" => "/api/v1/distributions/ask/species"
              },
              "name" => "Alaska",
              "slug" => "ask",
              "species_count" => 1537,
              "tdwg_code" => "ASK",
              "tdwg_level" => 3
            }
          ],
          "native" => [
            %{
              "id" => 151,
              "links" => %{
                "plants" => "/api/v1/distributions/afg/plants",
                "self" => "/api/v1/distributions/afg",
                "species" => "/api/v1/distributions/afg/species"
              },
              "name" => "Afghanistan",
              "slug" => "afg",
              "species_count" => 4544,
              "tdwg_code" => "AFG",
              "tdwg_level" => 3
            },
            %{
              "id" => 93,
              "links" => %{
                "plants" => "/api/v1/distributions/alb/plants",
                "self" => "/api/v1/distributions/alb",
                "species" => "/api/v1/distributions/alb/species"
              },
              "name" => "Albania",
              "slug" => "alb",
              "species_count" => 3429,
              "tdwg_code" => "ALB",
              "tdwg_level" => 3
            }
          ]
        },
        "duration" => nil,
        "edible" => false,
        "edible_part" => nil,
        "family" => "Urticaceae",
        "family_common_name" => "Nettle family",
        "flower" => %{"color" => nil, "conspicuous" => true},
        "foliage" => %{"color" => nil, "leaf_retention" => nil, "texture" => nil},
        "fruit_or_seed" => %{
          "color" => nil,
          "conspicuous" => nil,
          "seed_persistence" => nil,
          "shape" => nil
        },
        "genus" => "Urtica",
        "genus_id" => 1028,
        "growth" => %{
          "atmospheric_humidity" => 5,
          "bloom_months" => nil,
          "days_to_harvest" => nil
        },
        "id" => 190_500,
        "image_url" => "https://bs.plantnet.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248",
        "images" => %{
          "" => [
            %{
              "copyright" =>
                "© copyright of the Board of Trustees of the Royal Botanic Gardens, Kew.",
              "id" => 3_548_904,
              "image_url" =>
                "https://storage.googleapis.com/powop-assets/kew_profiles/PPCONT_009525_fullsize.jpg"
            }
          ],
          "bark" => [
            %{
              "copyright" => "Taken Aug 4, 2019 by Nelly Garnier (cc-by-sa)",
              "id" => 3_234_513,
              "image_url" =>
                "https://bs.plantnet.org/image/o/8179be49717a7e6fb436d4eedb7b346eca816d79"
            }
          ]
        },
        "links" => %{
          "genus" => "/api/v1/genus/urtica",
          "plant" => "/api/v1/plants/urtica-dioica",
          "self" => "/api/v1/species/urtica-dioica"
        },
        "observations" => "Europe to Siberia and W. China, NW. Africa",
        "rank" => "species",
        "scientific_name" => "Urtica dioica",
        "slug" => "urtica-dioica",
        "sources" => [
          %{
            "citation" => "https://plants.sc.egov.usda.gov/core/profile?symbol=URDI",
            "id" => "URDI",
            "last_update" => "2020-06-21T20:48:14.618Z",
            "name" => "USDA",
            "url" => "https://plants.usda.gov/core/profile?symbol=URDI"
          }
        ],
        "specifications" => %{"average_height" => %{"cm" => nil}, "growth_form" => nil},
        "status" => "accepted",
        "synonyms" => [
          %{
            "author" => "Kanitz",
            "id" => 30752,
            "name" => "Urtica major",
            "sources" => [
              %{
                "citation" =>
                  "POWO (2019). Plants of the World Online. Facilitated by the Royal Botanic Gardens, Kew. Published on the Internet; http://www.plantsoftheworldonline.org/ Retrieved 2020-07-18",
                "id" => "urn:lsid:ipni.org:names:857719-1",
                "last_update" => "2020-07-18T04:51:45.555Z",
                "name" => "POWO",
                "url" => "http://powo.science.kew.org/taxon/urn:lsid:ipni.org:names:857719-1"
              }
            ]
          }
        ],
        "vegetable" => false,
        "year" => 1753
      },
      "meta" => %{
        "images_count" => 36,
        "last_modified" => "2021-03-04T17:23:25.320Z",
        "sources_count" => 6,
        "synonyms_count" => 6
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

      assert {:ok, @success_resp} == Species.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Species.find(@id)
    end
  end

  describe "search" do
    @query "urtica-dioica"
    @path "https://trefle.io/api/v1/species/search"
    @success_resp %{
      "data" => [
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
          "synonyms" => ["Urtica major"],
          "year" => 1753
        },
        %{
          "author" => "Aiton",
          "bibliography" => "Hort. Kew. 3: 341 (1789)",
          "common_name" => "Stinging nettle",
          "family" => "Urticaceae",
          "family_common_name" => "Nettle family",
          "genus" => "Urtica",
          "genus_id" => 1028,
          "id" => 190_511,
          "image_url" => nil,
          "links" => %{
            "genus" => "/api/v1/genus/urtica",
            "plant" => "/api/v1/plants/urtica-gracilis",
            "self" => "/api/v1/species/urtica-gracilis"
          },
          "rank" => "species",
          "scientific_name" => "Urtica gracilis",
          "slug" => "urtica-gracilis",
          "status" => "accepted",
          "synonyms" => ["Urtica lyallii"],
          "year" => 1789
        }
      ],
      "links" => %{
        "first" => "/api/v1/species/search?page=1&q=urtica-dioica",
        "last" => "/api/v1/species/search?page=1&q=urtica-dioica",
        "self" => "/api/v1/species/search?q=urtica-dioica"
      },
      "meta" => %{"total" => 2}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token, q: @query}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Species.search(@query)
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
               Species.search(
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Species.search(@query)
    end
  end

  describe "report" do
    @id 190_511
    # Even in the remote case that the mock doesn't work, do not create fake report
    @notes "TEST"
    @body Jason.encode!(%{notes: @notes})
    @path "https://trefle.io/api/v1/species/#{@id}/report"
    @success_resp %{
      "data" => %{
        "accepted_by" => nil,
        "change_status" => "pending",
        "change_type" => "update",
        "changes" => nil,
        "correction" => nil,
        "created_at" => "2021-04-02T01:40:19.422Z",
        "id" => 58292,
        "notes" => nil,
        "record_id" => @id,
        "record_type" => "Species",
        "updated_at" => "2021-04-02T01:40:19.431Z",
        "user_id" => 5,
        "warning_type" => "report"
      },
      "meta" => %{"last_modified" => "2021-04-02T01:40:19.431Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :post,
        fn @path, @body, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Species.report(@id, @notes)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Species.report(@id, @notes)
    end
  end
end
