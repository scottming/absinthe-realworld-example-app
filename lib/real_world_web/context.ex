defmodule RealWorldWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- authorize(token) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case RealWorldWeb.Guardian.resource_from_token(token) do
      {:ok, user, %{"typ" => "token"}} ->
        {:ok, user}

      _ ->
        {:error, "invalid token"}
    end
  end
end
