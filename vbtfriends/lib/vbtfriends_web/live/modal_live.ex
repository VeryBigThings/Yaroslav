defmodule VbtfriendsWeb.ModalLive do
  use VbtfriendsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :show_modal, false)}
  end

  def render(assigns) do
    ~L"""
    <h1>Modal window</h1>
    <div id="underwater">
      <button phx-click="toggle-modal" class="p-4 mx-auto block mt-8">
        Open Modal
      </button>

      <%= if @show_modal do %>
         <div class="phx-modal"
              phx-window-keydown="toggle-modal"
              phx-key="escape"
              phx-capture-click="toggle-modal">
         <div class="phx-modal-content">
          <a href="#" class="phx-modal-close" phx-click="toggle-modal">&times</a>

        <div class="creatures mt-20">
          <p >Some text</p>
          <button  phx-click="toggle-modal"  class="p-4 mx-auto block mt-8">close</button>
        </div>
        </div>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end
end
