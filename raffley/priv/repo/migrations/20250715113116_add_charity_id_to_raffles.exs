defmodule Raffley.Repo.Migrations.AddCharityIdToRaffles do
  use Ecto.Migration

  def change do
    alter table(:raffles) do
      add :charity_id, references(:charities, type: :id)
    end

    # Add index for faster queries
    create index(:raffles, [:charity_id])
  end
end
