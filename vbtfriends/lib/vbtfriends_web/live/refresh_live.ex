defmodule VbtfriendsWeb.RefreshLive do
  use VbtfriendsWeb, :live_view
  use Timex

  alias VbtfriendsWeb.Sales

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(refresh: 1)

    if connected?(socket), do: schedule_refresh(socket)

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        new_orders: Sales.new_orders(),
        sales_amount: Sales.sales_amount(),
        expiration_time: expiration_time,
        satisfaction: Sales.satisfaction(),
       # time_remaining: time_remaining(expiration_time)
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

  </p>
      </div>


    </div>
    <div class="controls">

  <form phx-change="select-refresh">
    <label for="refresh">
      Refresh every:
    </label>
    <select name="refresh">
      <%= options_for_select(refresh_options(), @refresh) %>
    </select>
  </form>

  <button phx-click="refresh">
    <img src="images/refresh.svg" class="h-10 object-contain">

  </button>
</div>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_event("select-refresh", %{"refresh" => refresh}, socket) do
    refresh = String.to_integer(refresh)
    socket = assign(socket, refresh: refresh)
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
       # time_remaining: time_remaining(expiration_time)
      )
      schedule_refresh(socket)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  # defp time_remaining(expiration_time) do
  #   DateTime.diff(expiration_time, Timex.now())
  # end

  defp format_time(time) do
    time
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end

  defp schedule_refresh(socket) do
    Process.send_after(self(), :tick, socket.assigns.refresh * 1000)
  end
  defp refresh_options do
    [{"1s", 1},{"2s", 2}, {"5s", 5}, {"15s", 15}, {"30s", 30}]
  end

end
