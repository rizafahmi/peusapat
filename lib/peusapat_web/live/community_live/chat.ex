defmodule PeusapatWeb.CommunityLive.Chat do
  use PeusapatWeb, :live_view

  alias Peusapat.Topics
  alias Peusapat.Topics.Topic

  @impl true
  def mount(%{"community_slug" => slug}, _session, socket) do
    topics = Peusapat.Command.list_topics_by_community(slug)
    community = Peusapat.Command.get_community_by_slug(slug)
    changeset = Topic.changeset(%Topic{}, %{})

    socket =
      socket
      |> assign(form: to_form(changeset))
      |> assign(slug: slug)
      |> assign(topics: topics)
      |> assign(community: community)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"topic" => topic_params}, socket) do
    community = Peusapat.Command.get_community_by_slug(socket.assigns.slug)

    params =
      topic_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("community_id", community.id)

    case Topics.create_topic(params) do
      {:ok, _topic} ->
        socket =
          socket
          |> put_flash(:info, "Topic created successfully.")
          |> push_navigate(to: ~p"/rizafahmi")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(form: to_form(changeset))

        {:noreply, socket}
    end
  end

  def remove_email(email) do
    email
    |> String.split("@")
    |> Enum.at(0)
  end

  def get_readable_date(date) do
    Calendar.strftime(date, "%d %b %Y")
  end

  def render_md(text) do
    text
    |> Earmark.as_html!()
    |> raw()
  end
end
