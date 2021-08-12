defmodule VbtfriendsWeb.LightLive do
  use VbtfriendsWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end
  def render(assigns) do
    ~L"""

    <h2 class="text-6xl mb-8  font-bold text-center">Front Porch Light </h2>
      <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%" class="bg-red-400 block">
          <%= @brightness %>%
        </span>
      </div>


      <button phx-click="off"><img src="/images/light-off.svg" alt="" class="h-8 object-contain">

    </button>

    <button phx-click="down"><img src="/images/down.svg" alt="" class="h-8 object-contain">
    </button>

    <button phx-click="up"><img src="/images/up.svg" alt="" class="h-8 object-contain">
    </button>

    <button phx-click="on"><img src="/images/light-on.svg"  alt="" class="h-8 object-contain">

    </button>



    </div>

    """
  end
  def handle_event("on", _,socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}

  end
  def handle_event("off", _,socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}

  end
  def handle_event("up", _,socket) do

    socket = update(socket, :brightness, &(&1 + 10) )
    {:noreply, socket}

  end
  def handle_event("down", _,socket) do

    socket = update(socket, :brightness, &(&1 - 10) )
    {:noreply, socket}

  end

end
