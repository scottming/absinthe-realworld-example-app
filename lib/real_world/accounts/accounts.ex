defmodule RealWorld.Accounts do
  import Ecto.Query, only: [from: 2]

  alias RealWorld.Repo

  alias __MODULE__.{User, UserFollower}

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2, run_batch: &run_batch/5)
  end

  def query(UserFollower, %{col: :is_following, current_user: current_user}) do
    from q in UserFollower, where: q.user_id == ^current_user.id
  end

  def query(queryable, _) do
    queryable
  end

  def run_batch(UserFollower, _query, :followers, user_ids, repo_opts) do
    results =
      from(q in User,
        preload: [followers: :user],
        where: q.id in ^user_ids
      )
      |> Repo.all(repo_opts)

    for id <- user_ids do
      Enum.find(results, &(&1.id == id)) |> Map.get(:followers) |> Enum.map(& &1.user)
    end
  end

  def run_batch(UserFollower, _query, :following, user_ids, repo_opts) do
    results =
      from(q in User,
        preload: [following: :followee],
        where: q.id in ^user_ids
      )
      |> Repo.all(repo_opts)

    for id <- user_ids do
      Enum.find(results, &(&1.id == id)) |> Map.get(:following) |> Enum.map(& &1.followee)
    end
  end

  def run_batch(UserFollower, query, :is_following, user_ids, repo_opts) do
    results =
      from(q in query, where: q.followee_id in ^user_ids, select: q.followee_id)
      |> Repo.all(repo_opts)

    for id <- user_ids do
      if id in results, do: true, else: false
    end
  end

  def run_batch(queryable, query, col, inputs, repo_opts) do
    Dataloader.Ecto.run_batch(Repo, queryable, query, col, inputs, repo_opts)
  end
end
