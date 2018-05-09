defmodule IdoKeidoWeb.Requests.CountryTest do
  use IdoKeidoWeb.ConnCase, async: true
  import Mox

  alias IdoKeido.{Continent, Country, CountryResult, GeolocationMock}

  @ip "134.201.250.155"

  describe "GET /country/:ip" do
    test "returns country data", %{conn: conn} do
      country_result = %CountryResult{
        country: %Country{
          code: "US",
          name: "United States"
        },
        continent: %Continent{
          code: "NA",
          name: "North America"
        },
        ip: @ip
      }

      GeolocationMock
      |> stub(:country, fn @ip -> country_result end)

      expected_response = %{
        "continent" => %{"code" => "NA", "name" => "North America"},
        "country" => %{"code" => "US", "name" => "United States"},
        "ip" => "134.201.250.155"
      }

      response =
        conn
        |> get("/country/#{@ip}")
        |> json_response(200)

      assert response == expected_response
    end

    test "when IP is not found, returns 404 Not Found", %{conn: conn} do
      GeolocationMock
      |> stub(:country, fn @ip -> nil end)

      response =
        conn
        |> get("/country/#{@ip}")
        |> response(404)

      assert response == ""
    end
  end
end
