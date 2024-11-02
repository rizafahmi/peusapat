defmodule PeusapatWeb.ReplyLive.Delete do
  use PeusapatWeb, :live_view

  alias Peusapat.Topics
  alias Peusapat.Topics.{Reply, Topic}

  @impl true
  def mount(%{"community_slug" => community_slug, "reply_id" => reply_id}, _session, socket) do
    user = socket.assigns.current_user
    reply = Topics.get_reply!(reply_id)

    case Topics.delete_reply(%Reply{id: reply_id}) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Reply deleted successfully")
          |> push_navigate(to: ~p"/#{community_slug}/topics/#{reply.parent_id}")

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
