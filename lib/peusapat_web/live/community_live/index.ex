defmodule PeusapatWeb.CommunityLive.Index do
  use PeusapatWeb, :live_view

  alias Peusapat.Command
  alias Peusapat.Communities
  alias Peusapat.Communities.Community

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    socket = socket |> assign(:current_user, current_user)

    {:ok, stream(socket, :communities, Command.list_communities_by_user(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Community")
    |> assign(:community, Communities.get_community!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Community")
    |> assign(:community, %Community{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Communities")
    |> assign(:community, nil)
  end

  @impl true
  def handle_info({PeusapatWeb.CommunityLive.FormComponent, {:saved, community}}, socket) do
    {:noreply, stream_insert(socket, :communities, community)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    community = Communities.get_community!(id)
    {:ok, _} = Communities.delete_community(community)

    {:noreply, stream_delete(socket, :communities, community)}
  end
end
