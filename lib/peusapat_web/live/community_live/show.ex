defmodule PeusapatWeb.CommunityLive.Show do
  use PeusapatWeb, :live_view

  alias Peusapat.Communities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:community, Communities.get_community!(id))}
  end

  defp page_title(:show), do: "Show Community"
  defp page_title(:edit), do: "Edit Community"
end
