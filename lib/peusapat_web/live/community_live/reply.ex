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
                <svg
                  viewBox="0 0 1024 1024"
                  class="icon mr-2 w-6 h-6 rounded-full"
                  version="1.1"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="#000000"
                >
                  <g stroke-width="0"></g>
                  <g stroke-linecap="round" stroke-linejoin="round"></g>
                  <g>
                    <path
                      d="M512.002082 0C229.382031 0 0.237391 229.14464 0.237391 511.764692c0 174.074128 86.947522 327.832597 219.761454 420.281755 25.883932-90.133557 91.287193-158.031504 180.287937-189.033916 3.706629-1.295238 7.454906-2.519675 11.24483-3.681641 0.599724-0.183249 1.191119-0.383157 1.795008-0.562241a325.358734 325.358734 0 0 1 27.058392-6.867676c0.932904-0.195743 1.874138-0.370663 2.807042-0.558076a344.820619 344.820619 0 0 1 14.722398-2.619629 350.905321 350.905321 0 0 1 10.428538-1.453499c1.25359-0.158261 2.498851-0.329015 3.756606-0.470617a354.782705 354.782705 0 0 1 14.168485-1.357709h51.705393c4.756146 0.354004 9.453986 0.820456 14.122673 1.34938 1.320226 0.154096 2.627958 0.33318 3.939855 0.49977a344.791466 344.791466 0 0 1 14.393382 2.099035c3.415096 0.574736 6.805204 1.199448 10.166159 1.869974 1.149471 0.229061 2.315602 0.441464 3.456744 0.683019 9.008358 1.894962 17.825137 4.131434 26.446174 6.709415 1.066176 0.316521 2.115694 0.662196 3.177705 0.991211 3.223518 0.99954 6.426212 2.044893 9.591423 3.140223 89.283947 30.881634 154.903776 98.837888 180.900156 189.146364 132.722308-92.465818 219.603194-246.16598 219.603194-420.173472C1023.762609 229.140475 794.622134 0 512.002082 0z m0 725.320666c-130.373388 0-236.491262-103.560716-240.743473-232.897081-0.145766-0.091625-0.291533-0.16659-0.437299-0.258215-4.993537-93.35291 43.813188-165.06577 105.59728-206.971502 0.358169-0.24572 0.703843-0.49977 1.062012-0.741325 2.357249-1.582606 4.747817-3.081916 7.138384-4.577063 0.937069-0.58723 1.853315-1.199448 2.798713-1.770019 38.040842-23.106043 79.896597-35.179658 116.717167-34.47998 2.619629-0.08746 5.230928-0.199908 7.871381-0.199908 2.507181 0 4.976878 0.112448 7.4674 0.187414 28.237017-0.487276 59.406019 6.534495 89.562986 20.21154a241.022512 241.022512 0 0 1 61.725785 39.377728c50.226906 43.088521 86.589353 107.846246 82.18721 188.963115l-0.199908 0.116613c-4.185575 129.398836-110.328438 233.038683-240.747638 233.038683z"
                      fill="#A0D9F6"
                    >
                    </path>
                    <path
                      d="M376.414425 285.193868c0.354004-0.241556 0.703843-0.503935 1.062012-0.741325-0.358169 0.241556-0.703843 0.49977-1.062012 0.741325zM519.465317 243.612987c-2.490522-0.074966-4.960219-0.187414-7.467399-0.187414-2.640453 0-5.251752 0.112448-7.871381 0.199908 2.52384 0.049977 5.043514 0.104119 7.517377 0.270709a156.265649 156.265649 0 0 1 7.821403-0.283203zM472.27868 386.726351c-46.307874 81.237647-124.763467 153.204557-201.024236 105.697234 4.252212 129.336365 110.370085 232.897081 240.743474 232.897081 130.4192 0 236.566227-103.639847 240.747638-233.038683-63.724866 39.660931-230.814705-17.875114-280.466876-105.555632zM384.614821 279.87548c0.937069-0.583065 1.857479-1.199448 2.798714-1.770019-0.949563 0.574736-1.861644 1.186954-2.798714 1.770019zM609.028303 263.824527a260.296983 260.296983 0 0 1 61.725785 39.377728 241.139125 241.139125 0 0 0-61.725785-39.377728z"
                      fill="#FCE9EA"
                    >
                    </path>
                    <path
                      d="M453.974597 729.360475zM610.498461 738.656201c1.066176 0.316521 2.115694 0.662196 3.177705 0.99121-1.062012-0.329015-2.111529-0.67469-3.177705-0.99121zM440.380847 731.900973c0.932904-0.195743 1.874138-0.370663 2.807043-0.558076-0.937069 0.187414-1.878303 0.362333-2.807043 0.558076zM411.527447 739.33089c0.599724-0.183249 1.191119-0.383157 1.795008-0.562241-0.603889 0.179084-1.195284 0.378992-1.795008 0.562241zM566.164679 728.702444zM623.263425 742.787634c0.732996 0.25405 1.457663 0.512264 2.18233 0.770479a119.432585 119.432585 0 0 1-10.457692 22.110667c17.142118 26.396196 12.83993 141.48911-12.91906 123.397429l-45.095932-31.756232-44.979318-31.639619 2.956974-2.078211c-0.982881 0.024989-1.965763 0.074966-2.956974 0.074966-1.032858 0-2.053223-0.054142-3.077752-0.079131l2.961139 2.082376-44.979319 31.639619-45.095931 31.756232c-25.900591 18.124999-30.190285-97.405213-12.877413-123.534866a119.286819 119.286819 0 0 1-10.357737-21.914923c0.570571-0.204073 1.136977-0.408146 1.711713-0.603889-89.000744 30.998247-154.404005 98.900359-180.287938 189.033916 82.820253 57.652658 183.457313 91.482936 292.003238 91.482936 108.616725 0 209.316257-33.876091 292.161498-91.59122-25.983886-90.308476-91.603714-158.268895-180.891826-189.150529zM580.595543 731.263766c1.149471 0.229061 2.315602 0.441464 3.456744 0.68302-1.141142-0.241556-2.303108-0.458123-3.456744-0.68302zM468.338825 727.273934c1.25359-0.154096 2.498851-0.329015 3.756606-0.470617-1.257755 0.141602-2.503016 0.312356-3.756606 0.470617zM552.091982 726.790823c1.320226 0.149931 2.627958 0.33318 3.939856 0.49977-1.311897-0.162425-2.615464-0.34151-3.939856-0.49977z"
                      fill="#CFE07D"
                    >
                    </path>
                    <path
                      d="M408.928642 765.527179c3.440085-5.189281 7.729779-6.87184 12.877412-3.252671l45.095932 31.756231 42.01818 29.557243c1.028694 0.024989 2.044893 0.07913 3.077752 0.079131 0.991211 0 1.974092-0.049977 2.956973-0.074966l42.022345-29.561408 45.095932-31.756231c5.172622-3.652487 9.47481-1.911621 12.91906 3.390107a119.307643 119.307643 0 0 0 10.457691-22.110666l-2.18233-0.770479a307.358677 307.358677 0 0 0-9.591423-3.140223c-1.062012-0.329015-2.111529-0.67469-3.177705-0.991211a327.35365 327.35365 0 0 0-26.446174-6.709415c-1.141142-0.241556-2.307272-0.453958-3.456744-0.683019a331.80577 331.80577 0 0 0-24.559541-3.969009c-1.311897-0.16659-2.619629-0.349839-3.939855-0.49977a367.755907 367.755907 0 0 0-14.122673-1.34938h-51.705393a354.782705 354.782705 0 0 0-14.168485 1.357709c-1.257755 0.141602-2.503016 0.316521-3.756606 0.470617a337.67807 337.67807 0 0 0-25.150936 4.073128c-0.937069 0.187414-1.878303 0.362333-2.807042 0.558076a328.678041 328.678041 0 0 0-27.058392 6.867676c-0.603889 0.179084-1.195284 0.378992-1.795008 0.562241-3.789924 1.157801-7.538201 2.386403-11.24483 3.681641-0.570571 0.195743-1.141142 0.399816-1.711713 0.603889a119.361784 119.361784 0 0 0 10.353573 21.910759z"
                      fill="#FEFEFE"
                    >
                    </path>
                    <path
                      d="M602.073168 762.274508l-45.095932 31.756231-42.022345 29.561408-2.956973 2.078211 44.979318 31.639619 45.095932 31.756232c25.758989 18.091681 30.061178-97.001232 12.91906-123.397429-3.440085-5.305894-7.742273-7.04676-12.91906-3.394272zM421.806054 762.274508c-5.147633-3.619169-9.437327-1.93661-12.877412 3.252671-17.312873 26.129652-13.023179 141.659865 12.877412 123.534865l45.095932-31.756232 44.979319-31.639618-2.961139-2.082376-42.01818-29.557243-45.095932-31.752067z"
                      fill="#7EA701"
                    >
                    </path>
                    <path
                      d="M472.27868 386.726351c49.65217 87.680518 216.742009 145.216563 280.466876 105.555632l0.199908-0.116613c4.402143-81.116869-31.964469-145.874594-82.187211-188.963115a260.51355 260.51355 0 0 0-61.725785-39.377728c-30.156967-13.677045-61.325969-20.698816-89.562986-20.21154-2.627958 0.045812-5.247587 0.108284-7.821404 0.283203 8.337833 29.51976-8.267032 88.263583-39.369398 142.830161z"
                      fill="#F7B970"
                    >
                    </path>
                    <path
                      d="M472.27868 386.726351c31.102366-54.570742 47.711396-113.3104 39.369398-142.830161a148.931522 148.931522 0 0 0-7.517376-0.270709c-36.82057-0.699678-78.676325 11.373937-116.717167 34.47998-0.941234 0.570571-1.861644 1.186954-2.798714 1.770019-2.390567 1.495146-4.781135 2.994456-7.138384 4.577063-0.358169 0.241556-0.703843 0.49977-1.062012 0.741325-61.784092 41.905732-110.590817 113.618592-105.59728 206.971502 0.145766 0.091625 0.291533 0.16659 0.437299 0.258215 76.260769 47.507323 154.716362-24.459587 201.024236-105.697234z"
                      fill="#FBCE77"
                    >
                    </path>
                  </g>
                </svg>
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
                      class="mr-2 w-6 h-6 rounded-full"
                      src="https://flowbite.com/docs/images/people/profile-picture-5.jpg"
                      alt="{remove_email(reply.user.email)}"
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
          <.input
            field={@reply_form[:text]}
            type="textarea"
            id="reply-text"
            rows="5"
            placeholder="Reply..."
          />
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
