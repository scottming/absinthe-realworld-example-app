defmodule RealWorldWeb.Resolvers.Blog do
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
end
