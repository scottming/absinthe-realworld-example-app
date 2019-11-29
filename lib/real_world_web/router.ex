defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug RealWorldWeb.Context
  end

  scope "/" do
    pipe_through :graphql

    forward "/api", Absinthe.Plug,
      schema: RealWorldWeb.Schema
      # socket: RealWorldWeb.UserSocket

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: RealWorldWeb.Schema
      # socket: RealWorldWeb.UserSocket
  end
end
