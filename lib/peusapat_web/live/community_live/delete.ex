defmodule PeusapatWeb.CommunityLive.Delete do
  use PeusapatWeb, :live_view

  alias Peusapat.Topics
  alias Peusapat.Topics.Topic

  @impl true
  def mount(%{"community_slug" => community_slug, "topic_id" => topic_id}, _session, socket) do
    user = socket.assigns.current_user

    case Topics.delete_topic(%Topic{id: topic_id}) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Topic deleted successfully")
          |> push_navigate(to: ~p"/#{community_slug}")

        {:ok, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Something went wrong")
          |> push_navigate(to: ~p"/#{community_slug}")

        {:ok, socket}
    end
  end
end
