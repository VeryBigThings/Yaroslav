defmodule VbtfriendsWeb.ServersLive do
  use VbtfriendsWeb, :live_view

  alias Vbtfriends.Servers
  alias Vbtfriends.Servers.Server

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _url, socket) do
    server = Servers.get_server_by_name(name)

    socket =
      assign(socket,
        selected_server: server,
        page_title: "What's up #{server.name}?"
      )

    {:noreply, socket}
  end

  # This "handle_params" clause needs to assign socket data
  # based on whether the action is "new" or not.
  def handle_params(_params, _url, socket) do
    if socket.assigns.live_action == :new do

      # The live_action is "new", so the form is being
      # displayed. Therefore, assign an empty changeset
      # for the form. Also don't show the selected
      # server in the sidebar which would be confusing.

      changeset = Servers.change_server(%Server{})

      socket =
        assign(socket,
          selected_server: nil,
          changeset: changeset
        )

      {:noreply, socket}
    else

      # The live_action is NOT "new", so the form
      # is NOT being displayed. Therefore, don't assign
      # an empty changeset. Instead, just select the
      # first server in list. This previously happened
      # in "mount", but since "handle_params" is always
      # invoked after "mount", we decided to select the
      # default server here instead of in "mount".

      socket =
        assign(socket,
          selected_server: hd(socket.assigns.servers)
        )

      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers" class="flex justify-start">
      <div class="sidebar bg-blue-100 px-20 py-10">
        <nav>
        <%= live_patch "New Server",
        to: Routes.servers_path(@socket, :new),
        class: "button" %>

          <%= for server <- @servers do %>
            <div>
            <%= live_patch link_body(server),
            to: Routes.live_path(
                      @socket,
                      __MODULE__,
                      name: server.name
                ),
            class: if server == @selected_server, do: "active" %>
            </div>

          <% end %>
        </nav>
      </div>
      <div class="main bg-green-100 px-20 py-10">
        <div class="wrapper">
        <%= if @live_action == :new do %>
        <%= f = form_for @changeset, "#",
                  phx_submit: "save",
                  phx_change: "validate" %>
          <div class="field">
            <%= label f , :name %>
            <%= text_input f, :name, autocomplete: "off" %>
            <%= error_tag f, :name %>
          </div>

          <div class="field">
            <%= label f, :framework %>
            <%= text_input f, :framework, autocomplete: "off" %>
            <%= error_tag f, :framework %>
          </div>

          <div class="field">
            <%= label f, :size, "Size (MB)" %>
            <%= number_input f, :size, autocomplete: "off" %>
            <%= error_tag f, :size %>
          </div>

          <div class="field">
            <%= label f, :git_repo, "Git Repo" %>
            <%= text_input f, :git_repo, autocomplete: "off" %>
            <%= error_tag f, :git_repo %>
          </div>

          <%= submit "Save", phx_disable_with: "Saving..." %>

          <%= live_patch "Cancel",
              to: Routes.live_path(@socket, __MODULE__),
              class: "cancel" %>
          </form>
      <% else %>

          <div class="card">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.status %>">
                <%= @selected_server.status %>
              </span>
            </div>
            <div class="body">
              <div class="row">
                <div class="deploys">
                  <img src="images/deploy.svg"  class="h-8 object-contain">

                  <span>
                    <%= @selected_server.deploy_count %> deploys
                  </span>
                </div>
                <span>
                  <%= @selected_server.size %> MB
                </span>
                <span>
                  <%= @selected_server.framework %>
                </span>
              </div>
              <h3>Git Repo</h3>
              <div class="repo">
                <%= @selected_server.git_repo %>
              </div>
              <h3>Last Commit</h3>
              <div class="commit">
                <%= @selected_server.last_commit_id %>
              </div>
              <blockquote>
                <%= @selected_server.last_commit_message %>
              </blockquote>
            </div>
          </div>
          <% end %>
        </div>
      </div>
    </div>

    """
  end

  # This is a new function that handles the "save" event.
  def handle_event("save", %{"server" => params}, socket) do
    case Servers.create_server(params) do

      {:ok, server} ->

        # Prepend newly-minted server to list.

        socket =
          update(
            socket,
            :servers,
            fn servers -> [server | servers] end
          )

        # Navigate to the new server's detail page.
        # Invokes handle_params which already gets the
        # server and sets it as the selected server.

        socket =
          push_patch(socket,
            to:
              Routes.live_path(
                socket,
                __MODULE__,
                id: server.id
              )
          )

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->

        # Assign errored changeset for form.

        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end
    # This is a new function that handles the "validate" event.
    def handle_event("validate", %{"server" => params}, socket) do
      changeset =
        %Server{}
        |> Servers.change_server(params)
        |> Map.put(:action, :insert)

      socket = assign(socket, changeset: changeset)

      {:noreply, socket}
    end

  defp link_body(server) do


    assigns = %{name: server.name, status: server.status}

    ~L"""
    <span class="status <%= @status %> float-left mr-8"><%= @status %> </span>
    <img src="/images/server.svg" class="h-8 object-contain  float-left mr-4" >
    <%= @name %>
    """
  end
end
