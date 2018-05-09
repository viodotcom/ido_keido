defmodule IdoKeidoWeb.Requests.StatusTest do
  use IdoKeidoWeb.ConnCase, async: true

  describe "GET /status" do
    test "returns a status message", %{conn: conn} do
      response =
        conn
        |> get("/status")
        |> json_response(200)

      assert %{"status" => "ok", "date_time" => _date_time} = response
    end
  end
end
