defmodule RealWorldWeb.Schema.AccountsMutationTypes do
  use Absinthe.Schema.Notation

  alias RealWorldWeb.Schema.Middleware
  alias RealWorldWeb.Resolvers

  object :accounts_mutations do
    field :register, :user_payload do
      arg :input, non_null(:register_input)
      resolve &Resolvers.AccountsMutation.register/3
    end

    field :login, :session_payload do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.AccountsMutation.login/3
    end

    field :update_user, :user_payload do
      arg :input, non_null(:update_user_input)
      middleware Middleware.Authenticate
      resolve &Resolvers.AccountsMutation.update_user/3
    end

    field :follow_user, :followee_payload do
      arg :input, non_null(:follow_input)
      middleware Middleware.Authenticate
      resolve &Resolvers.AccountsMutation.follow/3
    end

    field :unfollow_user, :followee_payload do
      arg :input, non_null(:unfollow_input)
      middleware Middleware.Authenticate
      resolve &Resolvers.AccountsMutation.unfollow/3
    end
  end

  object :session_payload do
    field :session, :session
    field :errors, list_of(:input_error)
  end

  object :user_payload do
    field :user, :user
    field :errors, list_of(:input_error)
  end

  object :followee_payload do
    field :followee, :profile
    field :errors, list_of(:input_error)
  end

  input_object :follow_input do
    field :username, :string
  end

  input_object :unfollow_input do
    field :username, :string
  end

  input_object :register_input do
    field :email, non_null(:string)
    field :username, non_null(:string)
    field :password, non_null(:string)
    field :bio, :string
    field :image, :string
  end

  input_object :login_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :update_user_input do
    field :email, :string
    field :username, :string
    field :bio, :string
    field :image, :string
    # TODO: password
  end
end
