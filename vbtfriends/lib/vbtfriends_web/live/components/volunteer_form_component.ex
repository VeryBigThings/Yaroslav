defmodule VbtfriendsWeb.VolunteerFormComponent do
  use VbtfriendsWeb, :live_component

  alias Vbtfriends.Volunteers
  alias Vbtfriends.Volunteers.Volunteer

  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#",
          phx_submit: "save",
          phx_change: "validate",
          phx_target: @myself %>

      <div class="fiinline-block float-left mx-10eld">
        <%= text_input f, :name,
                      placeholder: "Name",
                      autocomplete: "off",
                      phx_debounce: "2000" %>
        <%= error_tag f, :name %>
      </div>

      <div class="inline-block float-left mx-10">
        <%= telephone_input f, :phone,
                            placeholder: "Phone XXX-XXX-XXXX",
                            autocomplete: "off",
                            phx_debounce: "blur" %>
        <%= error_tag f, :phone %>
      </div>

      <%= submit "Check In", phx_disable_with: "Saving...", class: "px-10" %>
    </form>
    """
  end

  def handle_event("save", %{"volunteer" => params}, socket) do
    case Volunteers.create_volunteer(params) do
      {:ok, _volunteer} ->
        changeset = Volunteers.change_volunteer(%Volunteer{})

        socket = assign(socket, changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"volunteer" => params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(params)
      |> Map.put(:action, :insert)

    socket =
      assign(socket,
        changeset: changeset
      )

    {:noreply, socket}
  end
end
