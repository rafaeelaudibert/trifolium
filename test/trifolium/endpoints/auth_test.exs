defmodule Trifolium.AuthTest do
  use ExUnit.Case, async: true
  import Mox

  alias Trifolium.Auth
  alias Trifolium.Config

  @http_client Trifolium.HTTPClientMock
  @token Config.token()

  describe "token" do
    @success_resp %{
      "token" =>
        "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOCwib3JpZ2luIjoiaHR0cDovL2xvY2FsaG9zdDoxMjM0IiwiaXAiOiI6OjEiLCJleHBpcmUiOiIyMDIwLTEyLTE0IDEzOjI3OjI0ICswMTAwIiwiZXhwIjoxNjA3OTQ4ODQ0fQ.ENYKCGT0r9rdIXzb_NsEnmcfrc2CebQmAySbGy4aKjM",
      "expiration" => "02-27-2021 12:47"
    }

    @body %{origin: "https://example.com", ip: nil}
          |> Jason.encode!()

    test "Returns tuple with expected token" do
      expect(
        @http_client,
        :post,
        fn "https://trefle.io/api/auth/claim",
           @body,
           %{"Content-Type" => "application/json"},
           [params: %{token: @token}] ->
          {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, @success_resp} == Auth.token("https://example.com")
    end

    test "With error, returns correctly" do
      expect(
        @http_client,
        :post,
        fn "https://trefle.io/api/auth/claim",
           @body,
           %{"Content-Type" => "application/json"},
           [params: %{token: @token}] ->
          {:ok,
           %HTTPoison.Response{
             body: %{error: "Unauthorized"} |> Jason.encode!(),
             status_code: 401
           }}
        end
      )

      assert {:error, 401, %{"error" => "Unauthorized"}} == Auth.token("https://example.com")
    end
  end
end
