defmodule RealWorldWeb.Can do
  alias RealWorld.Accounts.User
  alias RealWorld.Blog.Article

  def can?(%User{id: current_user_id}, action, %Article{user_id: user_id})
      when action in [:view] do
    current_user_id == user_id
  end
end
