defmodule PeusapatWeb.CommunityLive.Reply do
  use PeusapatWeb, :live_view

  alias Peusapat.Topics.Reply
  import PeusapatWeb.Live.Helpers

  @impl true
  def mount(%{"community_slug" => community_slug, "topic_id" => topic_id}, _session, socket) do
    user = socket.assigns.current_user
    topic = Peusapat.Commands.get_topic_preload!(topic_id)
    replies = Peusapat.Commands.list_replies(topic_id)
    community = Peusapat.Commands.get_community_by_slug(community_slug)

    socket =
      socket
      |> assign(topic: topic)
      |> assign(replies: replies)
      |> assign(user: user)
      |> assign(community: community)
      |> assign(reply_form: to_form(Reply.changeset(%Reply{}, %{user: user})))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"reply" => reply_params}, socket) do
    params =
      reply_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("parent_id", socket.assigns.topic.id)

    case Peusapat.Commands.create_reply(params) do
      {:ok, _reply} ->
        socket =
          socket
          |> put_flash(:info, "Reply created successfully")
          |> push_navigate(
            to: ~p"/#{socket.assigns.community.slug}/topics/#{socket.assigns.topic.id}"
          )

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Something went wrong")
          |> assign(reply_form: to_form(changeset))

        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="bg-white dark:bg-gray-900 py-8 lg:py-16 antialiased">
      <div class="max-w-2xl mx-auto px-4">
        <div class="flex flex-col mb-6">
          <article class="format">
            <h2 class="text-lg lg:text-2xl font-bold text-gray-900 dark:text-white">
              Diskusi Komunitas <%= @community.name %>
            </h2>
          </article>
        </div>
        <small>Pesan yang ingin dibalas:</small>
        <article class="p-6 mb-3 text-base bg-white border-gray-200 dark:border-gray-700 dark:bg-gray-900 border-l-8">
          <footer class="flex justify-between items-center mb-2">
            <div class="flex items-center">
              <p class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold">
                <img
                  src={"https://api.dicebear.com/9.x/avataaars/webp?seed=#{@topic.user.email}"}
                  class="w-6 h6 mr-2 rounded-full"
                />

                <%= PeusapatWeb.Live.Helpers.remove_email(@topic.user.email) %>
              </p>
              <p class="text-sm text-gray-600 dark:text-gray-400">
                <time pubdate datetime={@topic.inserted_at} title={@topic.inserted_at}>
                  <%= PeusapatWeb.Live.Helpers.get_readable_date(@topic.inserted_at) %>
                </time>
              </p>
            </div>
          </footer>
          <article class="format lg:format-lg">
            <%= PeusapatWeb.Live.Helpers.render_md(@topic.post) |> raw() %>
          </article>
        </article>
        <div>
          <%= for reply <- @replies do %>
            <!-- REPLIES -->
            <article class="p-6 mb-3 ml-6 lg:ml-12 text-base bg-white rounded-lg dark:bg-gray-900">
              <footer class="flex justify-between items-center mb-2">
                <div class="flex items-center">
                  <p class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold">
                    <img
                      src={"https://api.dicebear.com/9.x/avataaars/webp?seed=#{reply.user.email}"}
                      class="w-6 h-6 mr-2 rounded-full"
                    /><%= remove_email(reply.user.email) %>
                  </p>
                  <p class="text-sm text-gray-600 dark:text-gray-400">
                    <time pubdate datetime="{reply.inserted_at}" title="{reply.inserted_at}">
                      <%= get_readable_date(reply.inserted_at) %>
                    </time>
                  </p>
                </div>
                <!-- Dropdown menu
              <button
                id="dropdownComment2Button"
                data-dropdown-toggle="dropdownComment2"
                class="inline-flex items-center p-2 text-sm font-medium text-center text-gray-500 dark:text-gray-40 bg-white rounded-lg hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-50 dark:bg-gray-900 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
                type="button"
              >
                <svg
                  class="w-4 h-4"
                  aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="currentColor"
                  viewBox="0 0 16 3"
                >
                  <path d="M2 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3Zm6.041 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM14 0a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3Z" />
                </svg>
                <span class="sr-only">Comment settings</span>
              </button>

              <div
                id="dropdownComment2"
                class="hidden z-10 w-36 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600"
              >
                <ul
                  class="py-1 text-sm text-gray-700 dark:text-gray-200"
                  aria-labelledby="dropdownMenuIconHorizontalButton"
                >
                  <li>
                    <a
                      href="#"
                      class="block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                    >
                      Edit
                    </a>
                  </li>
                  <li>
                    <a
                      href="#"
                      class="block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                    >
                      Remove
                    </a>
                  </li>
                  <li>
                    <a
                      href="#"
                      class="block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                    >
                      Report
                    </a>
                  </li>
                </ul>
              </div>
              -->
              </footer>
              <p class="text-gray-500 dark:text-gray-400"><%= reply.text %></p>
            </article>
          <% end %>
        </div>

        <.simple_form for={@reply_form} id="reply-form" phx-submit="submit">
          <div class="py-2 px-4 mb-4 bg-white rounded-lg rounded-t-lg border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <.input
              field={@reply_form[:text]}
              type="textarea"
              id="reply-text"
              rows="5"
              placeholder="Reply..."
            />
          </div>
          <.button>Reply</.button>
          <.link
            navigate={~p"/#{@community.slug}"}
            class="py-2.5 px-5 me-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
          >
            Back to community
          </.link>
        </.simple_form>
      </div>
    </section>
    """
  end
end
