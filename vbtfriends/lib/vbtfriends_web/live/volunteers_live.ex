defmodule VbtfriendsWeb.VolunteersLive do
  use VbtfriendsWeb, :live_view

  alias Vbtfriends.Volunteers
  alias Vbtfriends.Volunteers.Volunteer


  def mount(_params, _session, socket) do
    if connected?(socket), do: Volunteers.subscribe()

    volunteers = Volunteers.list_volunteers()

    socket =
      assign(socket,
        volunteers: volunteers,
        recent_activity: nil
      )

    {:ok, socket, temporary_assigns: [volunteers: []]}
  end



  def handle_info({:volunteer_created, volunteer}, socket) do
    socket =
      update(
        socket,
        :volunteers,
        fn volunteers -> [volunteer | volunteers] end
      )

      socket =
        assign(socket,
          recent_activity: "#{volunteer.name} checked in!"
        )

    {:noreply, socket}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    socket =
      update(
        socket,
        :volunteers,
        fn volunteers -> [volunteer | volunteers] end
      )

      socket =
        assign(socket,
          recent_activity: "#{volunteer.name} checked
            #{if volunteer.checked_out, do: "out", else: "in"}!"
        )

    {:noreply, socket}
  end
end
