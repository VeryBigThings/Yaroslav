defmodule VbtfriendsWeb.TimerLive do
  use VbtfriendsWeb, :live_view
  use Timex

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1  class="text-6xl mb-8  font-bold text-center">Timer </h1>
    <div class="flex justify-center bg-white-100 ">
      <p class="m-4 font-semibold text-indigo-800 ">
        <%= if @time_remaining > 0 do %>
         <%= format_time(@time_remaining) %> left to nothing
        <% else %>
          Expired!
        <% end %>
       </p>
    </div>

    <button phx-click="refresh" class="m-auto block" >
      <img src="images/refresh.svg" class="h-10 object-contain">
    </button>

    """
  end

  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time

    socket =
      assign(socket,
        time_remaining: time_remaining(expiration_time)
      )

    {:noreply, socket}
  end

  defp time_remaining(expiration_time) do
    DateTime.diff(expiration_time, Timex.now())
  end

  defp format_time(time) do
    time
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end
