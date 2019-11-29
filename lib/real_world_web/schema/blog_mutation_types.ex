defmodule RealWorldWeb.Schema.BlogMutationTypes do
  use Absinthe.Schema.Notation

  alias RealWorldWeb.Schema.Middleware
  alias RealWorldWeb.Resolvers

  object :blog_mutations do
    field :create_article, :article_payload do
      arg :input, :create_article_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.create_article/3
    end

    field :update_article, :article_payload do
      arg :input, :update_article_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.update_article/3
    end

    field :delete_article, :delete_article_payload do
      arg :input, :delete_article_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.delete_article/3
    end

    field :add_comment, :comment_payload do
      arg :input, :add_comment_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.add_comment/3
    end

    field :remove_comment, :delete_comment_payload do
      arg :input, :remove_comment_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.remove_comment/3
    end

    field :favorite_article, :article_payload do
      arg :input, :favorite_article_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.favorite/3
    end

    field :unfavorite_article, :article_payload do
      arg :input, :unfavorite_article_input
      middleware Middleware.Authenticate
      resolve &Resolvers.BlogMutation.unfavorite/3
    end
  end

  object :article_payload do
    field :article, :article
    field :errors, list_of(:input_error)
  end

  object :comment_payload do
    field :comment, :comment
    field :errors, list_of(:input_error)
  end

  object :delete_article_payload do
    field :deleted_article_id, :id
    field :errors, list_of(:input_error)
  end

  object :delete_comment_payload do
    field :deleted_comment_id, :id
    field :errors, list_of(:input_error)
  end

  input_object :create_article_input do
    field :title, non_null(:string)
    field :description, non_null(:string)
    field :body, non_null(:string)
    field :tag_list, non_null(list_of(non_null(:string)))
    field :slug, :string
  end

  input_object :update_article_input do
    field :id, non_null(:id)
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tag_list, list_of(:string)
  end

  input_object :delete_article_input do
    field :id, :id
  end

  input_object :add_comment_input do
    field :article_id, non_null(:id)
    field :body, non_null(:string)
  end

  input_object :remove_comment_input do
    field :id, non_null(:id)
  end

  input_object :favorite_article_input do
    field :article_id, non_null(:id)
  end

  input_object :unfavorite_article_input do
    field :article_id, non_null(:id)
  end
end
