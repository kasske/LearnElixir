defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  alias Raffley.Charities
  import RaffleyWeb.CustomComponents


  def mount(_params, _session, socket) do
    # checking the stream after render to see that items are removed
    # IO.inspect(socket.assigns.streams.raffles, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn
    #     socket ->
    #       IO.inspect(socket.assigns.streams.raffles, label: "AFTER_RENDER")
    #       socket
    #   end)

    socket =
      assign(socket, :charity_options, Charities.charity_names_and_slugs())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
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

      <.filter_form form={@form} charity_options={@charity_options} />

      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input
        field={@form[:q]}
        type="search"
        placeholder="Search"
        autocomplete="off"
        phx-debounce="500"
      />
      <.input
        field={@form[:status]}
        type="select"
        prompt="Status"
        options={[:upcoming, :open, :closed]}
      />

      <.input
        field={@form[:charity]}
        type="select"
        prompt="Charity"
        options={@charity_options}
      />

      <.input
        field={@form[:sort_by]}
        type="select"
        prompt="Sort by"
        options={[
          Prize: "prize",
          "Price: High to Low": "ticket_price_desc",
          "Price: Low to High": "ticket_price_asc",
          Charity: "charity"
        ]}
      />

      <.link patch={~p"/raffles"}>Reset</.link>
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
        <div class="charity">
          {@raffle.charity.name}
        </div>
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

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by charity))
      |> Map.reject(fn {_key, value} -> value == "" end)

    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end
end
