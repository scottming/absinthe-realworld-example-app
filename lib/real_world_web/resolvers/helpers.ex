defmodule RealWorldWeb.Resolvers.Helpers do
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def custom_dataloader(source, resource) do
    fn parent, args, %{context: %{loader: loader} = ctx} = res ->
      col = res.definition.schema_node.identifier
      opts = [] |> Keyword.put_new(:args, %{col: col})
      do_dataloader(loader, source, resource, put_current_user(args, ctx), parent, opts)
    end
  end

  def custom_dataloader(source, resource, opts) do
    fn parent, args, %{context: %{loader: loader} = ctx} ->
      do_dataloader(loader, source, resource, put_current_user(args, ctx), parent, opts)
    end
  end

  defp put_current_user(args, ctx) do
    args |> Map.put(:current_user, Map.get(ctx, :current_user))
  end

  defp do_dataloader(loader, source, resource, args, parent, opts) do
    col = opts |> Keyword.get(:args) |> Map.get(:col)

    args =
      opts
      |> Keyword.get(:args, %{})
      |> Map.merge(args)

    loader
    |> Dataloader.load(source, {resource, args}, Keyword.new([{col, parent.id}]))
    |> on_load(fn loader ->
      result = Dataloader.get(loader, source, {resource, args}, Keyword.new([{col, parent.id}]))
      {:ok, result}
    end)
  end
end
