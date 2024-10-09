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

  @impl true
  def handle_params(%{"community_slug" => slug}, _url, socket) do
    # field :parent_id, :binary_id
    # belongs_to :user, Peusapat.Users.User
    # belongs_to :community, Peusapat.Communities.Community
    community_id = Peusapat.Command.get_community_by_slug(slug).id
    user_id = socket.assigns.current_user.id

    socket =
      socket
      |> assign(
        reply_form:
          to_form(Topic.changeset(%Topic{}, %{community_id: community_id, user_id: user_id}))
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"topic" => topic_params}, socket) do
    dbg(socket.assigns.reply_form.source.changes)

    params =
      topic_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("community_id", socket.assigns.reply_form.source.changes.community_id)

    case Topics.create_topic(params) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, reply_form: to_form(changeset))}
    end
  end

  def remove_email(email) do
    email
    |> String.split("@")
    |> Enum.at(0)
  end

  def get_readable_date(date) do
    Calendar.strftime(date, "%d %b %Y, %H:%M")
  end

  def render_md(text) do
    text
    |> Earmark.as_html!()
    |> raw()
  end
end
