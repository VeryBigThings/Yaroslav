defmodule VbtfriendsWeb.SalesLive do
  use VbtfriendsWeb, :live_view
  use Timex

  alias VbtfriendsWeb.Sales
  #alias VbtfriendsWeb.Licenses

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        new_orders: Sales.new_orders(),
        sales_amount: Sales.sales_amount(),
        expiration_time: expiration_time,
        satisfaction: Sales.satisfaction(),
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales </h1>
    <div id="dashboard">
      <div class="stats flex bg-white-100">
        <div class="stat  px-20 py-2 mx-2 my-2 rounded-2xl bg-blue-100">
          <span class="value text-blue-700">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat  px-20 py-2 mx-2 my-2 rounded-2xl bg-blue-100">
        <span class="value text-blue-700">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat  px-20 py-2 mx-2 my-2 rounded-2xl bg-blue-100">
          <span class="value text-blue-700">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
        <p class="m-4 font-semibold text-indigo-800">
    <%= if @time_remaining > 0 do %>
      <%= format_time(@time_remaining) %> left to save 20%
    <% else %>
      Expired!
    <% end %>
  </p>
      </div>

      <button phx-click="refresh" >
        <img src="images/refresh.svg" class="h-10 object-contain">

      </button>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time
    socket =
      assign(socket,
        new_orders: Sales.new_orders(),
        sales_amount: Sales.sales_amount(),
        expiration_time: expiration_time,
        satisfaction: Sales.satisfaction(),
        time_remaining: time_remaining(expiration_time)
      )
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
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
