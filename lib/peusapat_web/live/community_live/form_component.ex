defmodule PeusapatWeb.CommunityLive.FormComponent do
  use PeusapatWeb, :live_component

  alias Peusapat.Communities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage community records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="community-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:logo]} type="text" label="Logo" />
        <.input
          field={@form[:description]}
          type="textarea"
          label="Description"
          placeholder="A short description of the community. Markdown is supported."
          class="border-zinc-300 focus:border-zinc-400"
        />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Community</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{community: community} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Communities.change_community(community))
     end)}
  end

  @impl true
  def handle_event("validate", %{"community" => community_params}, socket) do
    changeset = Communities.change_community(socket.assigns.community, community_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"community" => community_params}, socket) do
    params =
      community_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    save_community(socket, socket.assigns.action, params)
  end

  defp save_community(socket, :edit, community_params) do
    case Communities.update_community(socket.assigns.community, community_params) do
      {:ok, community} ->
        notify_parent({:saved, community})

        {:noreply,
         socket
         |> put_flash(:info, "Community updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_community(socket, :new, community_params) do
    case Communities.create_community(community_params) do
      {:ok, community} ->
        notify_parent({:saved, community})

        {:noreply,
         socket
         |> put_flash(:info, "Community created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
