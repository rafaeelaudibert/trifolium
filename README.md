# Trifolium 🍀

![Trifolium Version 1.0.1](https://img.shields.io/badge/Trifolium-v1.0.1-brightgreen)
![Trefle Version 1.6.0](https://img.shields.io/badge/Trefle-v1.6.0-blue)


[Trefle](https://trefle.io/) API Wrapper for Elixir, built for ease of use, with some cool helper methods to easily handle pagination. Currently supports Trefle on v1.6.0.

## Installation 💻

The package can be installed by adding `trifolium` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:trifolium, "~> 0.1.0"}
  ]
end
```

The docs can be found on [HexDocs](https://hexdocs.pm/trifolium).

## Usage ⌨️

```elixir
defmodule YourApp.Trefle
  alias Trifolium.Endpoints.Plants

  def get_plant(id) do
    Plants.find(id)
  end

  def search_umid_plants(query) do
    Plants.search(q: query, filter: %{umidity: "20, 50"})
    # You could use umidity as an array and we would parse it
  end
end
```

For pagination you can use:

```elixir
defmodule YourApp.Trefle
  alias Trifolium.Endpoints.Plants

  def get_two_plants_pages(page) do
    page_1 = Plants.all(page: page)
    next_page = Trifolium.Navigation.next(page_1)

    {page_1, next_page}
  end
end
```

For every available method, please check [our documentation](https://hexdocs.pm/trifolium) on HexDocs.



## Disclaimer ⚠️

This library is not affiliated in any way to the original Trefle project, and we do not provide warranty of any kind that it will continue working with the latest Trefle version, as they could introduce breaking changes. For further information, please visit our [LICENSE](./LICENSE).

## Author 🧙‍♂️

- [RafaAudibert](https://www.rafaaudibert.dev)