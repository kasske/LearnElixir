defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles.Raffle
  alias Raffley.Charities

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:charity_options, Charities.charity_names_and_ids())
      |> apply_action(socket.assigns.live_action, params)

    {:ok, socket}
  end

  defp apply_action(socket, :new, _params) do
    raffle = %Raffle{}

    # we using the changeset to pass to to_form, so we can see default values in the new form
    # it is often defined on its own context like Admin.change_raffle/2
    changeset = Admin.change_raffle(raffle)

    socket
    |> assign(:page_title, "New Raffle")
    # "as" acts as a prefix for form field params | by default uses lowercase schema name so we removed it
    |> assign(:form, to_form(changeset))
    |> assign(:raffle, raffle)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    raffle = Admin.get_raffle!(id)

    # we using the changeset to pass to to_form, so we can see default values in the new form
    # it is often defined on its own context like Admin.change_raffle/2
    changeset = Admin.change_raffle(raffle)

    socket
    |> assign(:page_title, "Edit Raffle")
    # "as" acts as a prefix for form field params | by default uses lowercase schema name so we removed it
    |> assign(:form, to_form(changeset))
    |> assign(:raffle, raffle)
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="raffle-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:description]} type="textarea" label="Description" />
      <.input field={@form[:ticket_price]} type="number" label="Ticket Price" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={[:upcoming, :open, :closed]}
      />

      <.input
        field={@form[:charity_id]}
        type="select"
        label="Charity"
        prompt="Choose a charity"
        options={@charity_options}
      />

      <.input field={@form[:image_path]} label="Image Path" />

      <:actions>
        <.button phx-disable-with="Saving...">Save</.button>
      </:actions>
    </.simple_form>

    <.back navigate={~p"/admin/raffles"}>Back</.back>
    """
  end

  # so this validates live
  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Admin.change_raffle(socket.assigns.raffle, raffle_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    # either create or update a raffle in the database based on the live action
    save_raffle(socket, socket.assigns.live_action, raffle_params)
  end

  defp save_raffle(socket, :new, raffle_params) do
    case Admin.create_raffle(raffle_params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created successfully.")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      # if there is an error, we will re-assign the form with the changeset
      # this changeset contains error information so the form rerenders to show those
      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  defp save_raffle(socket, :edit, raffle_params) do
    case Admin.update_raffle(socket.assigns.raffle, raffle_params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle updated successfully.")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      # if there is an error, we will re-assign the form with the changeset
      # this changeset contains error information so the form rerenders to show those
      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
