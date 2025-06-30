defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery Raffle Coming Soon!
        <!-- named slot below -->
        <:details :let={emoji}>
          To be revealed tomorrow <%= emoji %>
        </:details>

        <:details>
          Any guesses?
        </:details>
      </.banner>
      <div class="raffles">
        <.raffle_card :for={raffle <- @raffles} raffle={raffle} />
      </div>
    </div>
    """
  end

  # those declarations are for a function right after this
  attr :raffle, Raffley.Raffles.Raffle, required: true

  def raffle_card(assigns) do
    # this is a component that renders another component
    # yes this is doable
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle.id}"}>
      <div class="card">
        <img src={@raffle.image_path} />
        <h2>{@raffle.prize}</h2>

        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end
end
