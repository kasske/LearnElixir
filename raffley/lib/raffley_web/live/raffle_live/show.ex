defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    # we can decide state either on mount or on handle params
    # handle params has access to url

    raffle = Raffles.get_raffle!(id)

    socket =
      socket
      |> assign(:raffle, raffle)
      |> assign(:page_title, raffle.prize)
      # |> assign(:featured_raffles, Raffles.featured_raffles(raffle))
      |> assign_async(:featured_raffles, fn ->
        {:ok, %{:featured_raffles => Raffles.featured_raffles(raffle)}}
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      <div class="raffle">
        <img src={@raffle.image_path} alt={@raffle.prize} />

        <section>
          <.badge status={@raffle.status} />
          <header>
          <div>
            <h2>{@raffle.prize}</h2>
            <h3>{@raffle.charity.name}</h3>
          </div>
            <div class="price">
              ${@raffle.ticket_price} / ticket
            </div>
          </header>

          <div class="description">
            {@raffle.description}
          </div>
        </section>
      </div>

      <div class="activity">
        <div class="left"></div>

        <div class="right">
          <.featured_raffles raffles={@featured_raffles} />
        </div>
      </div>
    </div>
    """
  end

  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4>Featured Raffles</h4>

    <!--
        built in component for async result
        in the :let we get the result of the async operation

        it uses an Elixir task to spawn a separate process to fetch data
        so our liveview shows, even if this fails for some reason

        if we go outside of the page, it automatically stops so no background work is done unnecessarily
      -->
      <.async_result :let={result} assign={@raffles}>
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>

    <!--
          failed slot is called when the async operation fails,
          in the let we pattern match error tuple if we need to show the reason
        -->
        <:failed :let={{:error, reason}}>
          <div class="failed">
            Yikes {reason}
          </div>
        </:failed>

    <!-- here we reference the result from the let keyword on parent -->
        <ul class="raffles">
          <li :for={raffle <- result}>
            <.link navigate={~p"/raffles/#{raffle.id}"}>
              <img src={raffle.image_path} alt={raffle.prize} />
              {raffle.prize}
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end
end
