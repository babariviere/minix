# Minix

Generate a nix dependency file for a project.

It's still a work in progress but it just "works".

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `minix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:minix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/minix](https://hexdocs.pm/minix).

## Usage

Generate a `deps.nix` from a mix.lock:

```sh
minix ./mix.lock > deps.nix
```
