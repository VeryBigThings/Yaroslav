defmodule VbtfriendsWeb.VolunteerComponent do
  use VbtfriendsWeb, :live_component

  alias Vbtfriends.Volunteers

  def render(assigns) do
    ~L"""
    <div class="volunteer  flex justify-between content-center mb-4 <%= if @volunteer.checked_out, do: "out" %>"
          id="<%= @volunteer.id %>">
      <div class="name">
        <%= @volunteer.name %>
      </div>
      <div class="phone">
        <img src="images/phone.svg"  class="float-left mr-4">
        <%= @volunteer.phone %>
      </div>
      <div class="status">
        <button phx-click="toggle-status"
                phx-value-id="<%= @volunteer.id %>"
                phx-disable-with="Saving..."
                phx-target="<%= @myself %>"
                class="px-8">
          <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
        </button>
      </div>
    </div>
    """
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} =
      Volunteers.update_volunteer(
        volunteer,
        %{checked_out: !volunteer.checked_out}
      )

    volunteers = Volunteers.list_volunteers()

    socket =
      assign(socket,
        volunteers: volunteers
      )

    :timer.sleep(500)
    {:noreply, socket}
  end
end
