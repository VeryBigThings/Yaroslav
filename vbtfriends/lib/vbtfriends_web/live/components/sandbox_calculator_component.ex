defmodule VbtfriendsWeb.SandboxCalculatorComponent do
  use VbtfriendsWeb, :live_component

  alias VbtfriendsWeb.SandboxCalculator

  def mount(socket) do
    {:ok, assign(socket, length: nil, width: nil, depth: nil, weight: 0)}
  end

  # def update(assigns, socket) do
  #   {:ok, assign(socket, assigns)}
  # end

  def render(assigns) do
    ~L"""
    <form phx-change="calculate" phx-target="<%= @myself %>"
          phx-submit="get-quote" class="mx-auto max-w-5xl">
      <div class="field flex justify-between items-center mb-8">
        <label for="length">Length:</label>
        <input type="number" name="length" value="<%= @length %>" class=" max-w-xl" />
        <span class="unit">feet</span>
      </div>
      <div class="field flex justify-between items-center  mb-8">
        <label for="length">Width:</label>
        <input type="number" name="width" value="<%= @width %>" class=" max-w-xl" />
        <span class="unit">feet</span>
      </div>
      <div class="field flex justify-between items-center  mb-8">
        <label for="length">Depth:</label>
        <input type="number" name="depth" value="<%= @depth %>" class=" max-w-xl" />
        <span class="unit">inches</span>
      </div>
      <div class="weight text-center mb-8">
        You need <%= @weight %> pounds
      </div>
      <button type="submit" class="mx-auto block px-8">
        Get Quote
      </button>
    </form>
    """
  end

  def handle_event("calculate", params, socket) do
    %{"length" => l, "width" => w, "depth" => d} = params

    weight = SandboxCalculator.calculate_weight(l, w, d)

    socket =
      assign(socket,
        length: l,
        width: w,
        depth: d,
        weight: weight
      )

    {:noreply, socket}
  end

  def handle_event("get-quote", _, socket) do
    weight = socket.assigns.weight
    price = SandboxCalculator.calculate_price(weight)

    send(self(), {:totals, weight, price})

    {:noreply, socket}
  end
end
