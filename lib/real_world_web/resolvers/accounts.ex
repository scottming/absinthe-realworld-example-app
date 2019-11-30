defmodule RealWorldWeb.Resolvers.Accounts do
  def me(_, _args, %{context: %{current_user: user}}) do
    {:ok, user}
  end
end
