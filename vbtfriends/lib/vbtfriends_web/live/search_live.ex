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
      <form phx-submit="zip-search" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 relative">
        <input type="text" name="zip" value="<%= @zip %>" class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
               placeholder="Zip Code"
               autofocus autocomplete="off"
               <%= if @loading, do: "readonly" %> />

        <button type="submit"  class="absolute right-0 top-6 right-8 bg-white pl-4 pr-4" >
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
            <li  class="p-4 rounded-lg border border-black-50 bg-blue-100">
              <div class="first-line flex justify-between">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open  rounded-lg border border-green-300 bg-green-300 m-4 p-8 block">Open</span>
                  <% else %>
                    <span class="closed  rounded-lg border border-red-300 bg-red-300 m-4 p-8 block">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg"  class="h-8 object-contain mr-4 float-left">
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg"  class="h-8 object-contain  mr-4 float-left">
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

        {:noreply, socket}
    end
  end
end
