defmodule VbtfriendsWeb.SalesDashboardLive do
  use VbtfriendsWeb, :live_view

  alias VbtfriendsWeb.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(10000, self(), :tick)
    end

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
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
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
