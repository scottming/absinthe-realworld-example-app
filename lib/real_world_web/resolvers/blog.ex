defmodule RealWorldWeb.Resolvers.Blog do
  alias RealWorld.Repo
  alias RealWorld.Blog

  def articles(_, args, _) do
    {:ok, Blog.list_articles(args)}
  end

  def feed(_, _args, %{context: %{current_user: user}}) do
    {:ok, Blog.feed(user)}
  end

  def tags(_, _args, _) do
    {:ok, Blog.list_tags()}
  end

  def favorited_for_article(article, _args, %{context: %{current_user: user}}) do
    case Blog.find_favorite(article, user) do
      %Blog.Favorite{} -> {:ok, true}
      nil -> {:ok, false}
      other -> other
    end
  end

  def author_for_article(article, _, _) do
    {:ok, article |> Ecto.assoc(:author) |> Repo.one()}
  end

  def author_for_comment(comment, _, _) do
    {:ok, comment |> Ecto.assoc(:author) |> Repo.one()}
  end
end
