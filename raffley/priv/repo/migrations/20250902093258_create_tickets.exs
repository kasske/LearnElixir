defmodule Raffley.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :price, :integer
      add :comment, :string
      add :raffle_id, references(:raffles, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      # on_delete: :delete_all means that if the raffle or user is deleted, all tickets are deleted
      # on_delete: can have other values like :nothing, :nilify_all, :update_all
      # :nothing means that if the raffle or user is deleted, the ticket is not deleted
      # :nilify_all means that if the raffle or user is deleted, the ticket is updated with nil values
      # :update_all means that if the raffle or user is deleted, the ticket is updated with the deleted raffle or user id

      timestamps(type: :utc_datetime)
    end

    create index(:tickets, [:raffle_id])
    create index(:tickets, [:user_id])
  end
end
