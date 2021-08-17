defmodule VbtfriendsWeb.AutocompleteLive do
  use VbtfriendsWeb, :live_view

  alias VbtfriendsWeb.Stores
  alias VbtfriendsWeb.Cities

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        zip: "",
        city: "",
        stores: [],
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Find a Store</h1>
    <div id="search">

      <form phx-submit="zip-search"  class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 relative inline-block w-2/4 float-left">
        <input type="text" name="zip" value="<%= @zip %>"
               placeholder="Zip Code"
               autofocus autocomplete="off"
               <%= if @loading, do: "readonly" %> />

        <button type="submit"  class="absolute right-0 top-6 right-8 bg-white pl-4 pr-4">
          <img src="images/search.svg"  class="h-8 object-contain">
        </button>
      </form>

      <form phx-submit="city-search" phx-change="suggest-city"  class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 relative inline-block w-2/4">
        <input type="text" name="city" value="<%= @city %>"
               placeholder="City"
               autocomplete="off"
               list="matches"
               phx-debounce="1000"
               <%= if @loading, do: "readonly" %> />

        <button type="submit"  class="absolute right-0 top-6 right-8 bg-white pl-4 pr-4">
          <img src="images/search.svg" class="h-8 object-contain">
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value="<%= match %>"><%= match %></option>
        <% end %>
      </datalist>


      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for store <- @stores do %>
            <li class="p-4 rounded-lg border border-black-50 bg-blue-100">
              <div class="first-line flex justify-between">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open  rounded-lg border border-green-300 bg-green-300 m-4 p-8 block">Open</span>
                  <% else %>
                    <span class="closed rounded-lg border border-red-300 bg-red-300 m-4 p-8 block">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg"  class="h-8 object-contain mr-4 float-left">
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg"  class="h-8 object-contain mr-4 float-left">
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

  def handle_event("city-search", %{"city" => city}, socket) do
    send(self(), {:run_city_search, city})

    socket =
      assign(socket,
        city: city,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    socket = assign(socket, matches: Cities.suggest(prefix))
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
        socket = assign(socket, stores: stores, loading: false)
        {:noreply, socket}
    end
  end

  def handle_info({:run_city_search, city}, socket) do
    case Stores.search_by_city(city) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{city}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
        socket = assign(socket, stores: stores, loading: false)
        {:noreply, socket}
    end
  end
end
