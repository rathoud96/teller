defmodule TellerWeb.Router do
  use TellerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TellerWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug TellerWeb.Auth
  end

  scope "/", TellerWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/enroll", TellerWeb do
    pipe_through :api

    post "/", AccountController, :enroll
  end

  scope "/accounts", TellerWeb do
    pipe_through [:api, :protected, :authenticate_api_user]

    get "/:id", AccountController, :show
    # post "/", AccountController, :create
    get "/:id/balance", AccountController, :account_balance
    # post "/:id/balance", AccountController, :create_account_balance
    get "/:id/details", AccountController, :account_details
    # post "/:id/details", AccountController, :create_account_details
    get "/:id/transactions", TransactionController, :show
    get "/:id/transactions/:transaction_id", TransactionController, :transaction
    # post "/:id/transactions", TransactionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", TellerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TellerWeb.Telemetry
    end
  end
end
