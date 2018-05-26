defmodule MetsTest do
  use ExUnit.Case, async: false
  use Plug.Test

  @opts Mets.Router.init([])

  test "greets the world" do
    assert Mets.hello() == :world
  end

  test "returns hello world and counts +1" do
    :ok = ConCache.delete(:mets_store, "key")

    # Create a test connection
    conn = conn(:get, "/hello")

    # Invoke the plug
    conn = Mets.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "world"

    res = ConCache.get(:mets_store, "key")
    assert is_map(res)
    assert res["counter"] == 1
  end

  test "counts concurrently with no races" do
    :ok = ConCache.delete(:mets_store, "key")

    tasks =
      Enum.reduce(0..99, [], fn _, acc ->
        t =
          Task.async(fn ->
            conn = conn(:get, "/hello")
            conn = Mets.Router.call(conn, @opts)
            assert conn.status == 200
            :ok
          end)

        [t | acc]
      end)

    for t <- tasks, do: :ok = Task.await(t)

    res = ConCache.get(:mets_store, "key")
    assert is_map(res)
    assert res["counter"] == 100
  end
end
