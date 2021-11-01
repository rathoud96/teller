# Teller

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To run the seed file:

  * run `mix run priv/repo/seeds.exs`

To test the application

  * run `mix test`

Environment Variable

  * use .envrc file
  * add `export SECRET_KEY = "your secret" (Base.encode32(:crypto.strong_rand_bytes))

Generate API_KEY

  * Teller.Encryption.encrypt("your_test")

Note:-
  * To get the API_KEY either user `/enroll` API or encrypt the `username` from `enrollments` table

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
