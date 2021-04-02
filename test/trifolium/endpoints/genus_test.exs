defmodule Trifolium.GenusTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Genus
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/genus/"
    @success_resp %{
      "data" => [
        %{
          "family" => %{
            "common_name" => nil,
            "id" => 32,
            "links" => %{
              "division_order" => "/api/v1/division_orders/orchidales",
              "genus" => "/api/v1/families/orchidaceae/genus",
              "self" => "/api/v1/families/orchidaceae"
            },
            "name" => "Orchidaceae",
            "slug" => "orchidaceae"
          },
          "id" => 14887,
          "links" => %{
            "family" => "/api/v1/families/orchidaceae",
            "plants" => "/api/v1/genus/aa/plants",
            "self" => "/api/v1/genus/aa",
            "species" => "/api/v1/genus/aa/species"
          },
          "name" => "Aa",
          "slug" => "aa"
        },
        %{
          "family" => %{
            "common_name" => "Grass family",
            "id" => 21,
            "links" => %{
              "division_order" => "/api/v1/division_orders/cyperales",
              "genus" => "/api/v1/families/poaceae/genus",
              "self" => "/api/v1/families/poaceae"
            },
            "name" => "Poaceae",
            "slug" => "poaceae"
          },
          "id" => 15849,
          "links" => %{
            "family" => "/api/v1/families/poaceae",
            "plants" => "/api/v1/genus/aakia/plants",
            "self" => "/api/v1/genus/aakia",
            "species" => "/api/v1/genus/aakia/species"
          },
          "name" => "Aakia",
          "slug" => "aakia"
        }
      ],
      "links" => %{
        "first" => "/api/v1/genus?page=1",
        "last" => "/api/v1/genus?page=2149",
        "next" => "/api/v1/genus?page=2",
        "self" => "/api/v1/genus"
      },
      "meta" => %{"total" => 42978}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Genus.all()
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

      assert {:ok, @success_resp} == Genus.all(page: page)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Genus.all()
    end
  end

  describe "find" do
    @id 32
    @path "https://trefle.io/api/v1/genus/#{@id}"
    @success_resp %{
      "data" => %{
        "family" => %{
          "common_name" => "Aster family",
          "id" => 13,
          "links" => %{
            "division_order" => "/api/v1/division_orders/asterales",
            "genus" => "/api/v1/families/asteraceae/genus",
            "self" => "/api/v1/families/asteraceae"
          },
          "name" => "Asteraceae",
          "slug" => "asteraceae"
        },
        "id" => @id,
        "links" => %{
          "family" => "/api/v1/families/asteraceae",
          "plants" => "/api/v1/genus/acanthospermum/plants",
          "self" => "/api/v1/genus/acanthospermum",
          "species" => "/api/v1/genus/acanthospermum/species"
        },
        "name" => "Acanthospermum",
        "slug" => "acanthospermum"
      },
      "meta" => %{"last_modified" => "2021-01-02T13:23:04.128Z"}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Genus.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Genus.find(@id)
    end
  end

  describe "plants" do
    @id 32
    @path "https://trefle.io/api/v1/genus/#{@id}/plants"
    @success_resp %{
      "data" => [
        %{
          "author" => "DC.",
          "bibliography" => "Prodr. 5: 522 (1836)",
          "common_name" => "Hispid starbur",
          "family" => "Asteraceae",
          "family_common_name" => "Aster family",
          "genus" => "Acanthospermum",
          "genus_id" => 32,
          "id" => 101_632,
          "image_url" =>
            "https://bs.floristic.org/image/o/2764867adf3ef9f9613e3ca3553177e5715035e0",
          "links" => %{
            "genus" => "/api/v1/genus/acanthospermum",
            "plant" => "/api/v1/plants/acanthospermum-hispidum",
            "self" => "/api/v1/species/acanthospermum-hispidum"
          },
          "rank" => "species",
          "scientific_name" => "Acanthospermum hispidum",
          "slug" => "acanthospermum-hispidum",
          "status" => "accepted",
          "synonyms" => ["Acanthospermum humile var. hispidum"],
          "year" => 1836
        },
        %{
          "author" => "(Loefl.) Kuntze",
          "bibliography" => "Revis. Gen. Pl. 1: 303 (1891)",
          "common_name" => "Paraguayan starbur",
          "family" => "Asteraceae",
          "family_common_name" => "Aster family",
          "genus" => "Acanthospermum",
          "genus_id" => 32,
          "id" => 101_629,
          "image_url" =>
            "https://d2seqvvyy3b8p2.cloudfront.net/7728d28e0d7f79fc8b1a746cae3b8e80.jpg",
          "links" => %{
            "genus" => "/api/v1/genus/acanthospermum",
            "plant" => "/api/v1/plants/acanthospermum-australe",
            "self" => "/api/v1/species/acanthospermum-australe"
          },
          "rank" => "species",
          "scientific_name" => "Acanthospermum australe",
          "slug" => "acanthospermum-australe",
          "status" => "accepted",
          "synonyms" => [
            "Acanthospermum xanthioides",
            "Melampodium australe",
            "Acanthospermum brasilum",
            "Orcya adhaerens",
            "Centrospermum xanthioides",
            "Acanthospermum brasilium",
            "Acanthospermum hirsutum"
          ],
          "year" => 1891
        }
      ],
      "links" => %{
        "first" => "/api/v1/plants?genus_id=32&page=1",
        "last" => "/api/v1/plants?genus_id=32&page=1",
        "self" => "/api/v1/plants?genus_id=32"
      },
      "meta" => %{"total" => 2}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Genus.plants(@id)
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
               Genus.plants(@id,
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Genus.plants(@id)
    end
  end

  describe "species" do
    @id 32
    @path "https://trefle.io/api/v1/genus/#{@id}/species"
    @success_resp %{
      "data" => [
        %{
          "author" => "DC.",
          "bibliography" => "Prodr. 5: 522 (1836)",
          "common_name" => "Hispid starbur",
          "family" => "Asteraceae",
          "family_common_name" => "Aster family",
          "genus" => "Acanthospermum",
          "genus_id" => 32,
          "id" => 101_632,
          "image_url" =>
            "https://bs.floristic.org/image/o/2764867adf3ef9f9613e3ca3553177e5715035e0",
          "links" => %{
            "genus" => "/api/v1/genus/acanthospermum",
            "plant" => "/api/v1/plants/acanthospermum-hispidum",
            "self" => "/api/v1/species/acanthospermum-hispidum"
          },
          "rank" => "species",
          "scientific_name" => "Acanthospermum hispidum",
          "slug" => "acanthospermum-hispidum",
          "status" => "accepted",
          "synonyms" => ["Acanthospermum humile var. hispidum"],
          "year" => 1836
        },
        %{
          "author" => "(Loefl.) Kuntze",
          "bibliography" => "Revis. Gen. Pl. 1: 303 (1891)",
          "common_name" => "Paraguayan starbur",
          "family" => "Asteraceae",
          "family_common_name" => "Aster family",
          "genus" => "Acanthospermum",
          "genus_id" => 32,
          "id" => 101_629,
          "image_url" =>
            "https://d2seqvvyy3b8p2.cloudfront.net/7728d28e0d7f79fc8b1a746cae3b8e80.jpg",
          "links" => %{
            "genus" => "/api/v1/genus/acanthospermum",
            "plant" => "/api/v1/plants/acanthospermum-australe",
            "self" => "/api/v1/species/acanthospermum-australe"
          },
          "rank" => "species",
          "scientific_name" => "Acanthospermum australe",
          "slug" => "acanthospermum-australe",
          "status" => "accepted",
          "synonyms" => [
            "Acanthospermum xanthioides",
            "Melampodium australe",
            "Acanthospermum brasilum",
            "Orcya adhaerens",
            "Centrospermum xanthioides",
            "Acanthospermum brasilium",
            "Acanthospermum hirsutum"
          ],
          "year" => 1891
        }
      ],
      "links" => %{
        "first" => "/api/v1/species?genus_id=32&page=1",
        "last" => "/api/v1/species?genus_id=32&page=1",
        "self" => "/api/v1/species?genus_id=32"
      },
      "meta" => %{"total" => 7}
    }

    test "returns tuple with expected values" do
      expect(
        @http_client,
        :get,
        fn @path, [], [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Genus.species(@id)
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
               Genus.species(@id,
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Genus.species(@id)
    end
  end
end
