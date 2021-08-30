defmodule VbtfriendsWeb.HeaderComponent do
  use VbtfriendsWeb, :live_component

  def render(assigns) do
    ~L"""
    <h1 class="text-5xl	mb-10">
      <%= @title %>
    </h1>
    <h2 class="text-center text-2xl text-gray-500 mb-8">
      <%= @subtitle %>
    </h2>
    """
  end
end
