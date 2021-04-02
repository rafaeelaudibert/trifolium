defmodule Trifolium.APITest do
  use ExUnit.Case, async: true

  alias Trifolium.API
  alias Trifolium.Config

  @token Config.token()

  describe "build_query_params/0" do
    test "uses default token" do
      %{token: token} = API.build_query_params()

      assert @token === token
    end
  end

  describe "build_query_params/1" do
    test "merges passed keyword with default token" do
      %{keyword_1: keyword_1, keyword_2: keyword_2} =
        API.build_query_params(keyword_1: "abc", keyword_2: "abcde")

      assert keyword_1 === "abc"
      assert keyword_2 === "abcde"
    end

    test "flattens map in parameters" do
      %{
        "map[this_key]" => map_this_key,
        "map[this_other_key]" => map_this_other_key,
        "other_map[key]" => other_map_key
      } =
        API.build_query_params(
          map: %{this_key: "is a", this_other_key: "is b"},
          other_map: %{key: "is c"}
        )

      assert map_this_key === "is a"
      assert map_this_other_key === "is b"
      assert other_map_key === "is c"
    end

    test "flattens array to a comma separated list" do
      %{
        number_list: number_list,
        str_list: str_list
      } =
        API.build_query_params(
          number_list: [2, 3, 4],
          str_list: ["str1", "str2", :atom]
        )

      assert number_list === "2,3,4"
      assert str_list === "str1,str2,atom"
    end
  end
end
