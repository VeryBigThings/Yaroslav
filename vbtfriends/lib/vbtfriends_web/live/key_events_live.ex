defmodule VbtfriendsWeb.KeyEventsLive do
  use VbtfriendsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       images: Enum.map(0..18, &"juggling-#{&1}.jpg"),
       current: 0,
       is_playing: false,
       timer: nil
     )}
  end

  def render(assigns) do
    ~L"""
    <h1>Juggling Key Events</h1>
    <div id="key-events" phx-window-keyup="update">
      <img src="/images/juggling/<%= Enum.at(@images, @current) %>">
      <div class="status">
        <%= Enum.at(@images, @current) %>
        <input type="number" value="<%= @current %>"
               phx-keyup="set-current"
               phx-key="Enter" />
        <div>
          <%= if @is_playing, do: "Playing", else: "Paused" %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("set-current", %{"key" => "Enter", "value" => value}, socket) do
    {:noreply, assign(socket, :current, String.to_integer(value))}
  end

  def handle_event("update", %{"key" => "ArrowRight"}, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_event("update", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, assign(socket, :current, previous(socket))}
  end

  def handle_event("update", %{"key" => "k"}, socket) do
    socket = update(socket, :is_playing, fn playing -> !playing end)

    socket =
      if socket.assigns.is_playing do
        {:ok, timer} = :timer.send_interval(250, self(), :tick)
        assign(socket, :timer, timer)
      else
        :timer.cancel(socket.assigns.timer)
        assign(socket, :timer, nil)
      end

    {:noreply, socket}
  end

  def handle_event("update", %{"key" => key}, socket) do
    IO.inspect(key)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, :current, next(socket))
    {:noreply, socket}
  end

  defp next(socket) do
    rem(
      socket.assigns.current + 1,
      Enum.count(socket.assigns.images)
    )
  end

  defp previous(socket) do
    rem(
      socket.assigns.current - 1 + Enum.count(socket.assigns.images),
      Enum.count(socket.assigns.images)
    )
  end
end
