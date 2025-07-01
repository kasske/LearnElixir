defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.list_raffles())
      |> assign(:form, to_form(%{}))

    # checking the stream after render to see that items are removed
    # IO.inspect(socket.assigns.streams.raffles, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn
    #     socket ->
    #       IO.inspect(socket.assigns.streams.raffles, label: "AFTER_RENDER")
    #       socket
    #   end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <pre>
      <%= inspect(@form, pretty: true) %>
    </pre>
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" />
        Mystery Raffle Coming Soon!
        <!-- named slot below -->
        <:details :let={emoji}>
          To be revealed tomorrow {emoji}
        </:details>

        <:details>
          Any guesses?
        </:details>
      </.banner>

      <.filter_form form={@form} />

      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form}>
      <.input field={@form[:q]} type="search" placeholder="Search" autocomplete="off" />
      <.input
        field={@form[:status]}
        type="select"
        prompt="Status"
        options={[:upcoming, :open, :closed]}
      />
      <.input
        field={@form[:sort_by]}
        type="select"
        prompt="Sort by"
        options={[:prize, :ticket_price]}
      />
    </.form>
    """
  end

  # those declarations are for a function right after this
  attr :raffle, Raffley.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def raffle_card(assigns) do
    # this is a component that renders another component
    # yes this is doable
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle.id}"} id={@id}>
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
