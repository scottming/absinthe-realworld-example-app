defmodule RealWorld.Seeds do
  alias RealWorld.Repo
  alias RealWorld.Accounts.{User, Encryption, UserFollower}
  alias RealWorld.Blog.{Article, Comment, Favorite}

  def run() do
    scott =
      %User{
        username: "scott",
        password: "abc123" |> Encryption.password_hashing(),
        email: "scottming@gmail.com",
        bio: "I'm a programmer"
      }
      |> Repo.insert!()

    _tk =
      %User{
        username: "tk",
        password: "abc123" |> Encryption.password_hashing(),
        email: "tk@gmail.com"
      }
      |> Repo.insert!()

    yam =
      %User{
        username: "yam",
        password: "abc123" |> Encryption.password_hashing(),
        email: "yam@gmail.com"
      }
      |> Repo.insert!()

    article1 =
      %Article{
        body: "some body",
        title: "some title 1",
        tag_list: ["tag1", "tag2"],
        slug: "some-title-1",
        user_id: scott.id
      }
      |> Repo.insert!()

    article2 =
      %Article{
        body: "some body",
        title: "some title 2",
        tag_list: ["tag1", "tag2"],
        slug: "some-title-2",
        user_id: yam.id
      }
      |> Repo.insert!()

    # generate some fake users to comment article1
    for i <- 42..1 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          # ignore hash
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _comment =
        %Comment{
          article_id: article1.id,
          body: "some comment body #{i}",
          user_id: user.id
        }
        |> Repo.insert!()
    end

    # generate some fake users to comment article2
    for i <- 43..64 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _comment =
        %Comment{
          article_id: article2.id,
          body: "some comment body #{i}",
          user_id: user.id
        }
        |> Repo.insert!()
    end

    # generate some fake users to favorite article1
    for _ <- 1..4 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _favorite =
        %Favorite{
          article_id: article1.id,
          user_id: user.id
        }
        |> Repo.insert!()
    end

    # generate some fake users to favorite article2
    for _ <- 1..8 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _favorite =
        %Favorite{
          article_id: article2.id,
          user_id: user.id
        }
        |> Repo.insert!()
    end

    :ok

    # generate some fake users to follow scott
    for i <- 1..4 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _followee =
        %UserFollower{
          user_id: user.id,
          followee_id: scott.id
        }
        |> Repo.insert!()

      if rem(i, 2) == 1 do
        %UserFollower{
          user_id: scott.id,
          followee_id: user.id
        }
        |> Repo.insert!()
      end
    end

    # generate some fake users to follow yam
    for i <- 1..8 do
      user =
        %User{
          username: Faker.Internet.user_name(),
          password: "abc123",
          email: Faker.Internet.email()
        }
        |> Repo.insert!()

      _followee =
        %UserFollower{
          user_id: user.id,
          followee_id: yam.id
        }
        |> Repo.insert!()

      if rem(i, 2) == 1 do
        %UserFollower{
          user_id: yam.id,
          followee_id: user.id
        }
        |> Repo.insert!()
      end
    end
  end
end
