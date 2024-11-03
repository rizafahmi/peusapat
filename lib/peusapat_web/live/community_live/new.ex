defmodule PeusapatWeb.CommunityLive.New do
  use PeusapatWeb, :live_view

  alias Peusapat.Communities
  alias Peusapat.Communities.Community

  def mount(_params, _session, socket) do
    changeset = Community.changeset(%Community{})

    socket =
      socket
      |> assign(form: to_form(changeset))

    {:ok, socket}
  end

  def handle_event("submit", %{"community" => community_params}, socket) do
    params =
      community_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Communities.create_community(params) do
      {:ok, community} ->
        dbg(community)

        socket =
          socket
          |> put_flash(:info, "Community created successfully.")
          |> push_navigate(to: ~p"/#{community.slug}")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(form: to_form(changeset))
          |> put_flash(:error, "Something went wrong")

        {:noreply, socket}
    end
  end
end
