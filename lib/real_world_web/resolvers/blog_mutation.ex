defmodule RealWorldWeb.Resolvers.BlogMutation do
  alias RealWorld.Blog
  alias RealWorld.Repo

  def create_article(_, %{input: params}, %{context: %{current_user: user}}) do
    params = params |> Map.merge(%{user_id: user.id})

    case Blog.create_article(params) do
      {:ok, article} -> {:ok, %{article: article}}
      other -> other
    end
  end

  def update_article(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, article} <- Repo.fetch(Blog.Article, params.id) do
      params
      |> Map.put(:user_id, user.id)
      |> Map.put(:article, article)
      |> internal_update_article
    else
      _ -> {:error, "not found"}
    end
  end

  defp internal_update_article(params) do
    case Blog.update_article(params.article, params) do
      {:ok, article} -> {:ok, %{article: article}}
      other -> other
    end
  end

  def delete_article(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, article} <- Repo.fetch(Blog.Article, params.id),
         true <- article.user_id == user.id do
      params
      |> Map.put(:article, article)
      |> internal_delete_article
    else
      false -> {:error, "invalid role"}
      _ -> {:error, "not found"}
    end
  end

  defp internal_delete_article(params) do
    case Blog.delete_article(params.article) do
      {:ok, _} -> {:ok, %{deleted_article_id: params.id}}
      other -> other
    end
  end

  def add_comment(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, article} <- Repo.fetch(Blog.Article) do
      params
      |> Map.put(:user_id, user.id)
      |> Map.put(:article_id, article.id)
      |> internal_add_comment()
    else
      _ -> {:error, "not found"}
    end
  end

  defp internal_add_comment(params) do
    case Blog.create_comment(params) do
      {:ok, comment} -> {:ok, %{comment: comment}}
      other -> other
    end
  end

  def remove_comment(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, comment} <- Repo.fetch(Blog.Comment, params.id),
         true = user.id == comment.user_id do
      params
      |> Map.put(:comment, comment)
      |> internal_delete_comment
    else
      false -> {:error, "invalid role"}
      _ -> {:error, "not found"}
    end
  end

  defp internal_delete_comment(params) do
    case Blog.delete_comment(params.comment) do
      {:ok, _} -> {:ok, %{deleted_comment_id: params.id}}
      other -> other
    end
  end

  def favorite(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, article} <- Repo.fetch(Blog.Article, params.article_id),
         {:ok, _favorite} <- Blog.favorite(user, article) do
      {:ok, %{article: article}}
    else
      _ -> {:error, "not found"}
    end
  end

  def unfavorite(_, %{input: params}, %{context: %{current_user: user}}) do
    with {:ok, article} <- Repo.fetch(Blog.Article, params.article_id),
         {:ok, _favorite} <- Blog.unfavorite(article, user) do
      {:ok, %{article: article}}
    else
      _ -> {:error, "not found"}
    end
  end
end
