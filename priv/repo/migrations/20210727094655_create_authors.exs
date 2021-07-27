defmodule Vbtfriends.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :bio, :text
      add :role, :string
      add :genre, :string
      add :user_id, references(:users, on_delete: :nothing),
      null: false

      timestamps()
    end

    create unique_index(:authors, [:user_id])
  end
end
