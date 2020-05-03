defmodule Minix do
  @moduledoc """
  Documentation for `Minix`.
  """

  def main([]) do
    compute("mix.lock")
  end

  def main([lockfile | _]) do
    compute(lockfile)
  end

  # TODO:
  # + generate a file called mix.deps.nix (we can override it with --output)
  # + this generates a map (or a list) ?

  defp compute(lockfile) do
    {out, _} = Code.eval_file(lockfile)

    # IO.inspect(out)

    nix =
      out
      |> Enum.map(fn {k, v} ->
        dep_to_nix(k, v)
        |> String.split("\n")
        |> Enum.map(&("  " <> &1))
        |> Enum.join("\n")
      end)
      |> Enum.join("\n")

    # TODO: we need to compile each dependencies
    # and map them to lib/#{name}-#{version}
    """
    {fetchGit, fetchHex}:
    [
    #{nix}
    ]
    """
    |> IO.puts()
  end

  def dep_to_nix(name, {:hex, pkg, version, _, _, _, _, _}) do
    {result, 0} =
      System.cmd("nix-prefetch-url", [
        "--type",
        "sha256",
        "https://repo.hex.pm/tarballs/#{pkg}-#{version}.tar"
      ])

    sha256 = String.trim(result)

    """
    {
      name = "#{name}";
      version = "#{version}";
      src = fetchHex {
        pkg = "#{pkg}";
        version = "#{version}";
        sha256 = "#{sha256}";
      };
    }
    """
  end

  def dep_to_nix(name, {:git, repo, rev, _}) do
    {result, 0} = System.cmd("nix-prefetch-git", [repo, "--rev", rev, "--quiet"])

    json = Jason.decode!(result)

    """
    {
      name = "#{name}";
      version = "#{json["rev"]}";
      src = fetchGit {
        url = "#{json["url"]}";
        rev = "#{json["rev"]}";
        sha256 = "#{json["sha256"]}";
      };
    }
    """
  end
end
