defmodule VbtfriendsWeb.RegisterLive do
  use VbtfriendsWeb, :live_view

  alias Vbtfriends.Accounts
  alias Vbtfriends.Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    {:ok, assign(socket, changeset: changeset, trigger_submit: false)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    changeset = registration_changeset(params)

    {:noreply,
     assign(
       socket,
       changeset: changeset,
       trigger_submit: changeset.valid?
     )}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = registration_changeset(params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  defp registration_changeset(params) do
    %User{}
    |> Accounts.change_user_registration(params)
    |> Map.put(:action, :insert)
  end
end
