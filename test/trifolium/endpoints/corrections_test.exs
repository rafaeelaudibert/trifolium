defmodule Trifolium.CorrectionsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Corrections
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "all" do
    @path "https://trefle.io/api/v1/corrections/"
    @success_resp %{
      "data" => [
        %{
          "id" => 4,
          "record_type" => "Species",
          "record_id" => 273_225,
          "user_id" => 31,
          "warning_type" => nil,
          "change_status" => "pending",
          "change_type" => "update",
          "accepted_by" => nil,
          "notes" => "Is the author okay ?",
          "created_at" => "2020-12-13T12:27:24.383Z",
          "updated_at" => "2020-12-13T12:27:24.383Z",
          "correction" => nil,
          "changes" => nil
        },
        %{
          "id" => 3,
          "record_type" => "Species",
          "record_id" => 116_854,
          "user_id" => 30,
          "warning_type" => nil,
          "change_status" => "pending",
          "change_type" => "update",
          "accepted_by" => nil,
          "notes" => "The height is wrong, it's way smaller",
          "created_at" => "2020-12-13T12:27:24.373Z",
          "updated_at" => "2020-12-13T12:27:24.373Z",
          "correction" => %{
            "scientific_name" => "Carex praegracilis",
            "maximum_height_value" => 30,
            "maximum_height_unit" => "cm"
          },
          "changes" => nil
        }
      ],
      "links" => %{
        "self" => "/api/v1/corrections",
        "first" => "/api/v1/corrections?page=1",
        "last" => "/api/v1/corrections?page=1"
      },
      "meta" => %{
        "total" => 2
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

      assert {:ok, @success_resp} == Corrections.all()
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Corrections.all()
    end
  end

  describe "find" do
    @id 7
    @path "https://trefle.io/api/v1/corrections/#{@id}"
    @success_resp %{
      "data" => %{
        "id" => @id,
        "record_type" => "Species",
        "record_id" => 116_854,
        "user_id" => 35,
        "warning_type" => nil,
        "change_status" => "pending",
        "change_type" => "update",
        "accepted_by" => nil,
        "notes" => "The height is wrong, it's way smaller",
        "created_at" => "2020-12-13T12:27:24.457Z",
        "updated_at" => "2020-12-13T12:27:24.457Z",
        "correction" => %{
          "scientific_name" => "Carex praegracilis",
          "maximum_height_value" => 30,
          "maximum_height_unit" => "cm"
        },
        "changes" => nil
      },
      "meta" => %{
        "last_modified" => "2020-12-13T12:27:24.457Z"
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

      assert {:ok, @success_resp} == Corrections.find(@id)
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

      assert {:error, 401, %{"error" => "Unauthorized"}} == Corrections.find(@id)
    end
  end
end
