defmodule PeusapatWeb.Live.Helpers do
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
    |> String.trim()
    |> Earmark.as_html!()
  end
end
