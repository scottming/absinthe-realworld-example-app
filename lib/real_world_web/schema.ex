defmodule RealWorldWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias RealWorld.{Blog, Accounts}
  alias RealWorldWeb.Schema.Middleware

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++
      [
        Middleware.ChangesetErrors
      ]
  end

  defp apply(middleware, _, _, _) do
    middleware
  end

  import_types __MODULE__.AccountsTypes
  import_types __MODULE__.AccountsMutationTypes
  import_types __MODULE__.BlogTypes
  import_types __MODULE__.BlogMutationTypes

  node interface do
    resolve_type fn
      %Accounts.User{}, _ ->
        :profile

      %Blog.Article{}, _ ->
        :article

      %Blog.Comment{}, _ ->
        :comment

      _, _ ->
        nil
    end
  end

  query do
    import_fields :accounts_queries
    import_fields :blog_queries

    node field do
      resolve fn
        %{type: :profile, id: local_id}, _ ->
          {:ok, Accounts.Users.get_user!(local_id)}

        %{type: :article, id: local_id}, _ ->
          {:ok, Blog.get_article!(local_id)}

        %{type: :comment, id: local_id}, _ ->
          {:ok, Blog.get_comment!(local_id)}

        _, _ ->
          {:error, "unknown node"}
      end
    end
  end

  mutation do
    import_fields :accounts_mutations
    import_fields :blog_mutations
  end

  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Blog, Blog.data())
      |> Dataloader.add_source(Accounts, Accounts.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
