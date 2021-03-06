defmodule VbtfriendsWeb.Admin.PageController do
  use VbtfriendsWeb, :controller

  alias Vbtfriends.Admin
  alias Vbtfriends.Admin.Page

  plug :require_existing_author
  plug :authorize_page when action in [:edit, :update, :delete]

  def index(conn, _params) do
    pages = Admin.list_pages()
    render(conn, "index.html", pages: pages)
  end

  def new(conn, _params) do
    changeset = Admin.change_page(%Page{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"page" => page_params}) do
    case Admin.create_page(conn.assigns.current_author, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    page = Admin.get_page!(id)
    render(conn, "show.html", page: page)
  end

  def edit(conn, _) do
    changeset = Admin.change_page(conn.assigns.page)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"page" => page_params}) do
    case Admin.update_page(conn.assigns.page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _page} = Admin.delete_page(conn.assigns.page)

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: Routes.admin_page_path(conn, :index))
  end

  defp require_existing_author(conn, _) do
    author = Admin.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  defp authorize_page(conn, _) do
    page = Admin.get_page!(conn.params["id"])

    if conn.assigns.current_author.id == page.author_id do
      assign(conn, :page, page)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: Routes.cms_page_path(conn, :index))
      |> halt()
    end
  end
end
