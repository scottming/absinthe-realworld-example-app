defmodule RealWorldWeb.Schema.BlogTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  import RealWorldWeb.Resolvers.Helpers, only: [custom_dataloader: 2, custom_dataloader: 3]

  alias RealWorldWeb.Resolvers
  alias RealWorldWeb.Schema.Middleware
  alias RealWorld.{Blog, Accounts}

  object :blog_queries do
    field :articles, list_of(:article) do
      arg :limit, :integer
      arg :offset, :integer
      arg :tag, list_of(:string)
      resolve &Resolvers.Blog.articles/3
    end

    field :feed, list_of(:article) do
      middleware Middleware.Authenticate
      resolve &Resolvers.Blog.feed/3
    end

    field :tags, list_of(:string) do
      resolve &Resolvers.Blog.tags/3
    end
  end

  node object(:article) do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tag_list, list_of(:string)
    field :created_at, :string
    field :updated_at, :string

    field :favorited, :boolean do
      middleware Middleware.Authenticate
      resolve custom_dataloader(Blog, {:one, Blog.Favorite}, args: %{col: :favorited})
    end

    field :comments, list_of(:comment) do
      arg :author_name, :string
      resolve dataloader(Blog, :comments, args: %{scope: :article})
    end

    field :favorites_count, :integer, resolve: custom_dataloader(Blog, {:one, Blog.Favorite})

    field :author, :profile, resolve: dataloader(Accounts)
  end

  node object :comment do
    field :body, :string
    field :author, :profile, resolve: dataloader(Accounts)
    field :inserted_at, :string
    field :updated_at, :string
  end
end
