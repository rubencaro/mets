defmodule Mets.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    :ok =
      ConCache.update(:mets_store, "key", fn prev ->
        new = Map.update(prev || %{}, "counter", 1, &(&1 + 1))
        {:ok, new}
      end)

    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
