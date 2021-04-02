defmodule Trifolium.DistributionsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Distributions
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/distributions/"
    @success_resp %{
      "data" => [
        %{
          "children" => [],
          "id" => 446,
          "links" => %{
            "plants" => "/api/v1/distributions/tcs-ab/plants",
            "self" => "/api/v1/distributions/tcs-ab",
            "species" => "/api/v1/distributions/tcs-ab/species"
          },
          "name" => "Abkhaziya",
          "parent" => %{
            "id" => 272,
            "links" => %{
              "plants" => "/api/v1/distributions/tcs/plants",
              "self" => "/api/v1/distributions/tcs",
              "species" => "/api/v1/distributions/tcs/species"
            },
            "name" => "Transcaucasus",
            "slug" => "tcs",
            "species_count" => 5227,
            "tdwg_code" => "TCS",
            "tdwg_level" => 3
          },
          "slug" => "tcs-ab",
          "species_count" => 0,
          "tdwg_code" => "TCS-AB",
          "tdwg_level" => 4
        },
        %{
          "children" => [],
          "id" => 694,
          "links" => %{
            "plants" => "/api/v1/distributions/bzn-ac/plants",
            "self" => "/api/v1/distributions/bzn-ac",
            "species" => "/api/v1/distributions/bzn-ac/species"
          },
          "name" => "Acre",
          "parent" => %{
            "id" => 78,
            "links" => %{
              "plants" => "/api/v1/distributions/bzn/plants",
              "self" => "/api/v1/distributions/bzn",
              "species" => "/api/v1/distributions/bzn/species"
            },
            "name" => "Brazil North",
            "slug" => "bzn",
            "species_count" => 12863,
            "tdwg_code" => "BZN",
            "tdwg_level" => 3
          },
          "slug" => "bzn-ac",
          "species_count" => 0,
          "tdwg_code" => "BZN-AC",
          "tdwg_level" => 4
        },
        %{
          "children" => [],
          "id" => 447,
          "links" => %{
            "plants" => "/api/v1/distributions/tcs-ad/plants",
            "self" => "/api/v1/distributions/tcs-ad",
            "species" => "/api/v1/distributions/tcs-ad/species"
          },
          "name" => "Adzhariya",
          "parent" => %{
            "id" => 272,
            "links" => %{
              "plants" => "/api/v1/distributions/tcs/plants",
              "self" => "/api/v1/distributions/tcs",
              "species" => "/api/v1/distributions/tcs/species"
            },
            "name" => "Transcaucasus",
            "slug" => "tcs",
            "species_count" => 5227,
            "tdwg_code" => "TCS",
            "tdwg_level" => 3
          },
          "slug" => "tcs-ad",
          "species_count" => 0,
          "tdwg_code" => "TCS-AD",
          "tdwg_level" => 4
        }
      ],
      "links" => %{
        "first" => "/api/v1/distributions?page=1",
        "last" => "/api/v1/distributions?page=37",
        "next" => "/api/v1/distributions?page=2",
        "self" => "/api/v1/distributions?page=1"
      },
      "meta" => %{"total" => 726}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Distributions.all()
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

      assert {:ok, @success_resp} == Distributions.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Distributions.all()
    end
  end

  describe "find" do
    @id 355
    @path "https://trefle.io/api/v1/distributions/#{@id}"
    @success_resp %{
      "data" => %{
        "children" => [],
        "id" => 355,
        "links" => %{
          "plants" => "/api/v1/distributions/asp/plants",
          "self" => "/api/v1/distributions/asp",
          "species" => "/api/v1/distributions/asp/species"
        },
        "name" => "Amsterdam-St.Paul Is",
        "parent" => %{
          "id" => 743,
          "links" => %{
            "plants" => "/api/v1/distributions/90/plants",
            "self" => "/api/v1/distributions/90",
            "species" => "/api/v1/distributions/90/species"
          },
          "name" => "Subantarctic Islands",
          "slug" => "90",
          "species_count" => 882,
          "tdwg_code" => "90",
          "tdwg_level" => 2
        },
        "slug" => "asp",
        "species_count" => 82,
        "tdwg_code" => "ASP",
        "tdwg_level" => 3
      },
      "meta" => %{"last_modified" => "2020-08-11T17:43:04.434Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Distributions.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Distributions.find(@id)
    end
  end

  describe "plants" do
    @id "bul"
    @path "https://trefle.io/api/v1/distributions/#{@id}/plants"
    @success_resp %{
      "data" => [
        %{
          "id" => 183_086,
          "common_name" => "European mountain ash",
          "slug" => "sorbus-aucuparia",
          "scientific_name" => "Sorbus aucuparia",
          "year" => 1753,
          "bibliography" => "Sp. Pl.: 477 (1753)",
          "author" => "L.",
          "status" => "accepted",
          "rank" => "species",
          "family_common_name" => "Rose family",
          "genus_id" => 677,
          "image_url" =>
            "https://bs.floristic.org/image/o/63073d2fbf45b90701279405ecc2eec0272906ed",
          "synonyms" => [
            "Pyrenia aucuparia",
            "Aucuparia silvestris",
            "Pyrus lanuginosa",
            "Sorbus altaica",
            "Sorbus lanuginosa",
            "Sorbus cordata",
            "Sorbus subserrata",
            "Sorbus anadyrensis",
            "Sorbus boissieri",
            "Sorbus caucasigena",
            "Mespilus aucuparia",
            "Sorbus monticola",
            "Pyrus boissieri"
          ],
          "genus" => "Sorbus",
          "family" => "Rosaceae",
          "links" => %{
            "self" => "/api/v1/species/sorbus-aucuparia",
            "plant" => "/api/v1/plants/sorbus-aucuparia",
            "genus" => "/api/v1/genus/sorbus"
          }
        },
        %{
          "id" => 1_164_724,
          "common_name" => "Christmastree",
          "slug" => "abies-alba",
          "scientific_name" => "Abies alba",
          "year" => 1756,
          "bibliography" => "Gard. Dict. ed. 7: n.º 1 (1756)",
          "author" => "Mill.",
          "status" => "accepted",
          "rank" => "species",
          "family_common_name" => "Pine family",
          "genus_id" => 4,
          "image_url" =>
            "https://bs.floristic.org/image/o/7928c21ee9fdc5ffa423501d3ba54084247cf9a9",
          "synonyms" => [
            "Abies nobilis",
            "Pinus heterophylla",
            "Pinus abies",
            "Abies pectinata",
            "Pinus picea",
            "Abies taxifolia",
            "Abies minor",
            "Abies picea",
            "Abies abies",
            "Abies chlorocarpa",
            "Abies pardei",
            "Picea pectinata",
            "Pinus pectinata",
            "Pinus baldensis",
            "Picea tenuifolia",
            "Abies alba var. pardei",
            "Peuce abies",
            "Abies alba subsp. pardei",
            "Picea metensis",
            "Picea rinzi",
            "Abies argentea",
            "Abies candicans",
            "Picea pyramidalis",
            "Abies baldensis",
            "Abies vulgaris",
            "Picea kukunaria",
            "Abies alba subsp. apennina",
            "Abies metensis",
            "Pinus lucida",
            "Abies miniata"
          ],
          "genus" => "Abies",
          "family" => "Pinaceae",
          "links" => %{
            "self" => "/api/v1/species/abies-alba",
            "plant" => "/api/v1/plants/abies-alba",
            "genus" => "/api/v1/genus/abies"
          }
        }
      ],
      "links" => %{
        "self" => "/api/v1/plants?zone_id=#{@id}",
        "first" => "/api/v1/plants?page=1&zone_id=#{@id}",
        "last" => "/api/v1/plants?page=1&zone_id=#{@id}"
      },
      "meta" => %{
        "total" => 4
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

      assert {:ok, @success_resp} == Distributions.plants(@id)
    end

    test "accepts filter options" do
      filter = %{author: "Rafael"}
      filter_not = %{common_name: "abcde"}
      order = %{atmospheric_humidity: "ASC"}
      range = ",15"
      page = 5

      expect(
        @http_client,
        :get,
        fn @path,
           [],
           [
             params: %{
               :token => @token,
               :range => ",15",
               :page => 5,
               "filter[author]" => "Rafael",
               "filter_not[common_name]" => "abcde",
               "order[atmospheric_humidity]" => "ASC"
             }
           ] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} ==
               Distributions.plants(@id,
                 filter: filter,
                 filter_not: filter_not,
                 order: order,
                 range: range,
                 page: page
               )
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Distributions.plants(@id)
    end
  end

  describe "species" do
    @id 15
    @path "https://trefle.io/api/v1/distributions/#{@id}/species"
    @success_resp %{
      "data" => [
        %{
          "author" => "(Cav.) Trin. ex Steud.",
          "bibliography" => "Nomencl. Bot., ed. 2, 2: 324 (1841)",
          "common_name" => "Common reed",
          "family" => "Poaceae",
          "family_common_name" => "Grass family",
          "genus" => "Phragmites",
          "genus_id" => 3364,
          "id" => 166_081,
          "image_url" =>
            "https://bs.plantnet.org/image/o/1155e1614588374ce93aedb701ae8483e2cae45f",
          "links" => %{
            "genus" => "/api/v1/genus/phragmites",
            "plant" => "/api/v1/plants/phragmites-australis",
            "self" => "/api/v1/species/phragmites-australis"
          },
          "rank" => "species",
          "scientific_name" => "Phragmites australis",
          "slug" => "phragmites-australis",
          "status" => "accepted",
          "synonyms" => [
            "Phragmites communis",
            "Arundo australis",
            "Arundo pseudophragmites",
            "Donax australis",
            "Phragmites australis subsp. americanus",
            "Phragmites communis subsp. berlandieri",
            "Phragmites australis var. flavescens",
            "Remirea diffusa",
            "Phragmites chilensis",
            "Arundo filiformis",
            "Cynodon phragmites",
            "Arundo vulgaris",
            "Phragmites breviglumis",
            "Phragmites jahandiezii",
            "Phragmites humilis",
            "Czernya arundinacea",
            "Phragmites hirsutus",
            "Phragmites nagus",
            "Cenchrus frutescens",
            "Phragmites flavescens",
            "Oxyanthe phragmites",
            "Arundo barbata",
            "Trichoon phragmites",
            "Phragmites pungens",
            "Phragmites communis f. salsa",
            "Phragmites australis var. salsa",
            "Phragmites stenophyllus",
            "Phragmites australis var. turkestanicus",
            "Phragmites australis var. striatopictus",
            "Phragmites willkommianus",
            "Phragmites fissifolius"
          ],
          "year" => 1841
        },
        %{
          "author" => "L.",
          "bibliography" => "Sp. Pl.: 85 (1753)",
          "common_name" => "Common wheat",
          "family" => "Poaceae",
          "family_common_name" => "Grass family",
          "genus" => "Triticum",
          "genus_id" => 134,
          "id" => 190_033,
          "image_url" =>
            "https://bs.plantnet.org/image/o/d4d05e22148e878ca3728beda0139b6dbe42fa3c",
          "links" => %{
            "genus" => "/api/v1/genus/triticum",
            "plant" => "/api/v1/plants/triticum-aestivum",
            "self" => "/api/v1/species/triticum-aestivum"
          },
          "rank" => "species",
          "scientific_name" => "Triticum aestivum",
          "slug" => "triticum-aestivum",
          "status" => "accepted",
          "synonyms" => [
            "Triticum cereale",
            "Triticum sativum",
            "Triticum vulgare",
            "Triticum hybernum",
            "Agropyron ichyostachyum",
            "Triticum sibiricum",
            "Frumentum triticum",
            "Triticum vavilovii var. vavilovomilturum",
            "Triticum aestivum subsp. inflatum",
            "Triticum hieminflatum",
            "Triticum vavilovii",
            "Triticum aestivum var. arnualru-claviformum",
            "Triticum aristatum",
            "Triticum aestivum var. muticum",
            "Triticum koeleri",
            "Triticum aestivum var. ferrugineum",
            "Triticum bucharicum",
            "Triticum vavilovii var. ramocoeruleum",
            "Triticum labile",
            "Triticum aestivum var. lutescens",
            "Triticum tustella",
            "Triticum vavilovii var. ramomuticum",
            "Triticum inflatum",
            "Triticum aestivum var. miltura",
            "Triticum aestivum var. vigorovii",
            "Triticum martius",
            "Triticum aestivum var. vavilovianum",
            "Aegilops straussii",
            "Triticum antiquorum var. vavilovianum",
            "Triticum horstianum"
          ],
          "year" => 1753
        }
      ],
      "links" => %{
        "first" => "/api/v1/species?page=1&zone_id=15",
        "last" => "/api/v1/species?page=57&zone_id=15",
        "next" => "/api/v1/species?page=2&zone_id=15",
        "self" => "/api/v1/species?zone_id=15"
      },
      "meta" => %{"total" => 1130}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Distributions.species(@id)
    end

    test "accepts filter options" do
      filter = %{author: "Rafael"}
      filter_not = %{common_name: "abcde"}
      order = %{atmospheric_humidity: "ASC"}
      range = ",15"
      page = 5

      expect(
        @http_client,
        :get,
        fn @path,
           [],
           [
             params: %{
               :token => @token,
               :range => ",15",
               :page => 5,
               "filter[author]" => "Rafael",
               "filter_not[common_name]" => "abcde",
               "order[atmospheric_humidity]" => "ASC"
             }
           ] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} ==
               Distributions.species(@id,
                 filter: filter,
                 filter_not: filter_not,
                 order: order,
                 range: range,
                 page: page
               )
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Distributions.species(@id)
    end
  end
end
