defmodule VbtfriendsWeb.Router do
  use VbtfriendsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VbtfriendsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about-us", AboutusController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end
  # add an authentication plug to the router that will allow us to lock down certain routes after a user has used our new session controller to sign-in
  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, Hello.Accounts.get_user!(user_id))
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", VbtfriendsWeb do
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
      live_dashboard "/dashboard", metrics: VbtfriendsWeb.Telemetry
    end
  end
end
