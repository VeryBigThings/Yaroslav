defmodule VbtfriendsWeb.TopSecretLive do
  use VbtfriendsWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~L"""
    <h1>Top Secret</h1>
    <div id="top-secret">
      <img src="images/spy.svg" class="h-20 object-contain  float-left mr-4">
      <div class="mission">
        <h2>Your Mission</h2>
        <h3>00<%= @current_user.id %></h3>
        <p>
          (should you choose to accept it)
        </p>
        <p>
          is detailed below...
        </p>
      </div>
    </div>
    """
  end
end
