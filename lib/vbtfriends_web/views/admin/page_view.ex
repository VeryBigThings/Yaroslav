defmodule VbtfriendsWeb.Admin.PageView do
  use VbtfriendsWeb, :view
  alias Vbtfriends.Admin

  def author_name(%Admin.Page{author: author}) do
    author.user.name
  end
end
