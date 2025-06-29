defmodule RaffleyWeb.CustomComponents do
  use RaffleyWeb, :html

  # those declarations are for a function right after this
  attr :status, :atom, values: [:upcoming, :open, :closed], default: :upcoming
  attr :class, :string, default: nil

  def badge(assigns) do
    # this is function component
    # we reference assigns values with @ symbol
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :open && "text-lime-600 border-lime-600",
      @status == :upcoming && "text-amber-600 border-amber-600",
      @status == :closed && "text-gray-600 border-gray-600",
      @class
    ]}>
      {@status}
    </div>
    """
  end

  # those declarations are for a function right after this, it recieves a slot
  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(🎉 😎 🤯) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>

      <div :for={detail <- @details} class="details">
        {render_slot(detail, @emoji)}
      </div>
    </div>
    """
  end
end
