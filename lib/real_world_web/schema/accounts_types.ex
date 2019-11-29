defmodule RealWorldWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import RealWorldWeb.Resolvers.Helpers, only: [custom_dataloader: 3]

  alias RealWorld.Accounts
  alias RealWorldWeb.Resolvers
  alias RealWorldWeb.Schema.Middleware

  object :accounts_queries do
    field :me, :user do
      resolve &Resolvers.Accounts.me/3
    end
  end

  object :user do
    field :email, :string
    field :username, :string
    field :bio, :string
    field :image, :string
  end

  node object(:profile) do
    field :username, :string
    field :bio, :string
    field :image, :string

    field :followers, list_of(:profile) do
      resolve custom_dataloader(Accounts, {:many, Accounts.UserFollower}, args: %{col: :followers})
    end

    field :following, list_of(:profile) do
      resolve custom_dataloader(Accounts, {:many, Accounts.UserFollower}, args: %{col: :following})
    end

    field :is_following, :boolean do
      middleware Middleware.Authenticate

      resolve custom_dataloader(Accounts, {:one, Accounts.UserFollower},
                args: %{col: :is_following}
              )
    end
  end

  object :session do
    field :user, :user
    field :token, :string
  end
end
