defmodule RealWorldWeb.Resolvers.AccountsMutation do
  alias RealWorld.Accounts

  def register(_, %{input: params} = _args, _info) do
    case Accounts.Auth.register(params) do
      {:ok, user} -> {:ok, user}
      other -> other
    end
  end

  def login(_, params, _info) do
    case Accounts.Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          user |> RealWorldWeb.Guardian.encode_and_sign(%{}, token_type: :token)

        {:ok, %{session: %{user: user, token: jwt}}}

      other ->
        other
    end
  end

  def update_user(_, %{input: params}, %{context: %{current_user: user}}) do
    case Accounts.Users.update_user(user, params) do
      {:ok, user} ->
        {:ok, %{user: user}}

      other ->
        other
    end
  end

  def follow(_, %{input: %{username: username}}, %{context: %{current_user: user}}) do
    case Accounts.Users.get_by_username(username) do
      followee = %Accounts.User{} ->
        user
        |> Accounts.Users.follow(followee)

        {:ok, %{followee: followee}}

      nil ->
        {:error, "no such followee"}
    end
  end

  def unfollow(_, %{input: %{username: username}}, %{context: %{current_user: user}}) do
    case Accounts.Users.get_by_username(username) do
      followee = %Accounts.User{} ->
        user
        |> Accounts.Users.unfollow(followee)

        {:ok, %{followee: followee}}

      nil ->
        {:error, "no such followee"}
    end
  end
end
