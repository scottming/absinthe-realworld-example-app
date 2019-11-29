defmodule RealWorldWeb.Resolvers.Accounts do
  import Ecto.Query, only: [from: 2]

  alias RealWorld.Repo
  alias RealWorld.Accounts

  def me(_, _args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def is_following?(followee, _, %{context: %{current_user: user}}) do
    {:ok, Accounts.Users.is_following?(user, followee)}
  end

  def followers(user, _, _) do
    query =
      from q in Accounts.User,
        join: uf in Accounts.UserFollower,
        on: uf.user_id == q.id,
        where: uf.followee_id == ^user.id

    {:ok, query |> Repo.all()}
  end

  def following(user, _, _) do
    query =
      from q in Accounts.User,
        join: uf in Accounts.UserFollower,
        on: uf.user_id == q.id,
        where: uf.user_id == ^user.id

    {:ok, query |> Repo.all()}
  end
end
