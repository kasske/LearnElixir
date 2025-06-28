defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  alias Raffley.Rules

  def index(conn, _params) do
    emojis = ~w(👍 🤩 🤪 🤪 🤪) |> Enum.random() |> String.duplicate(5)

    rules = Rules.list_rules()

    render(conn, :index, emojis: emojis, rules: rules)
  end

  def show(conn, %{"id" => id}) do
    # keys and values in params are always strings

    rule = Rules.get_rule(id)

    render(conn, :show, rule: rule)
  end
end
