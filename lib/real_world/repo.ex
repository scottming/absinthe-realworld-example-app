defmodule RealWorld.Repo do
  use Ecto.Repo,
    otp_app: :real_world,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [where: 2]

  def fetch(query, id) do
    query
    |> where(id: ^id)
    |> fetch
  end

  def fetch_by(query, condition) do
    query
    |> where(^condition)
    |> fetch
  end

  def fetch(query) do
    case all(query) do
      [] -> {:error, query}
      [obj] -> {:ok, obj}
      _ -> raise "Expected one or no items, got many items #{inspect(query)}"
    end
  end
end
