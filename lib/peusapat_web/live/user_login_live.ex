defmodule PeusapatWeb.UserLoginLive do
  use PeusapatWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in with Github
        <:subtitle>
          Please use your Github account to sign in.
        </:subtitle>
      </.header>
      <div class="my-6 flex justify-center">
        <.link
          navigate={~p"/auth/github"}
          phx-disable-with="Logging in..."
          class="text-white bg-teal-700 hover:bg-teal-800 focus:ring-4 focus:ring-teal-300 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 mr-2 dark:bg-blue-600 dark:hover:bg-teal-700 focus:outline-none dark:focus:ring-teal-800"
        >
          Sign in with Github <span aria-hidden="true">→</span>
        </.link>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
