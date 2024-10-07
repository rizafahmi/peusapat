defmodule Peusapat.Command do
  @moduledoc """
  Command module for additional functions for every context
  """

  import Ecto.Query, warn: false
  alias Peusapat.Repo

  @doc """
  Returns the list of communities by user_id.

  ## Examples

      iex> list_communities_by_user(123)
      [%Community{}, ...]

  """
  def list_communities_by_user(user_id) do
    query =
      from c in Peusapat.Communities.Community,
        where: c.user_id == ^user_id,
        order_by: [desc: c.inserted_at]

    Repo.all(query)
  end
end
