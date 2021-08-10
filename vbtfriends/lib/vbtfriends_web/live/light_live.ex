defmodule VbtfriendsWeb.LightLive do
  use VbtfriendsWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end
  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>


      <button phx-click="off"><img srs="images/light-on.svg">

    Off
    </button>

    <button phx-click="on">
    On
    </button>

    </div>

    """
  end
  def handle_event("on", _,socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}

  end

end
