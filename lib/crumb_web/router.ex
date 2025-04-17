defmodule CrumbWeb.Router do
  use CrumbWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CrumbWeb.Plugs.AuthorizeApiKey
  end

  scope "/api", CrumbWeb do
    pipe_through :api

    post "/identify", EventController, :identify
    post "/track", EventController, :track
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:crumb, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CrumbWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
