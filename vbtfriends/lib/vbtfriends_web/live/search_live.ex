defmodule VbtfriendsWeb.SearchLive do
  use VbtfriendsWeb, :live_view

  alias VbtfriendsWeb.Stores

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        zip: "",
        stores: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h2  class="text-6xl mb-8  font-bold text-center">Find a Store</h2>
    <p class="">By zip (zip: "59602", "80204")</p>
    <div class=" bg-white-100">
      <form phx-submit="zip-search" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex">
        <input type="text" name="zip" value="<%= @zip %>" class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
               placeholder="Zip Code"
               autofocus autocomplete="off"
               <%= if @loading, do: "readonly" %> />

        <button type="submit"  class="flex-shrink-0 bg-teal-500 hover:bg-teal-700 border-teal-500 hover:border-teal-700 text-sm border-4 text-white py-1 px-2 rounded" >
          <img src="images/search.svg"  class="h-8 object-contain">
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for store <- @stores do %>
            <li>
              <div class="first-line">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open">Open</span>
                  <% else %>
                    <span class="closed">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg"  class="h-8 object-contain">
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg"  class="h-8 object-contain">
                  <%= store.phone_number %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})

    socket =
      assign(socket,
        zip: zip,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    case Stores.search_by_zip(zip) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{zip}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
         socket =
          socket
            |> clear_flash()
            |> assign(stores: stores, loading: false)
    end
  end
end
