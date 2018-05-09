defmodule IdoKeidoWeb.Requests.CityTest do
  use IdoKeidoWeb.ConnCase, async: true
  import Mox

  alias IdoKeido.{
    City,
    CityResult,
    Continent,
    Country,
    Location,
    GeolocationMock
  }

  @ip "134.201.250.155"

  describe "GET /country/:ip" do
    test "returns city data", %{conn: conn} do
      city_result = %CityResult{
        city: %City{
          name: "Los Angeles"
        },
        location: %Location{
          accuracy_radius: 5,
          latitude: 34.0544,
          longitude: -118.244,
          time_zone: "America/Los_Angeles"
        },
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
      |> stub(:city, fn @ip -> city_result end)

      expected_response = %{
        "city" => %{"name" => "Los Angeles"},
        "continent" => %{"code" => "NA", "name" => "North America"},
        "country" => %{"code" => "US", "name" => "United States"},
        "ip" => "134.201.250.155",
        "location" => %{
          "accuracy_radius" => 5,
          "latitude" => 34.0544,
          "longitude" => -118.244,
          "time_zone" => "America/Los_Angeles"
        }
      }

      response =
        conn
        |> get("/city/#{@ip}")
        |> json_response(200)

      assert response == expected_response
    end

    test "when IP is not found, returns 404 Not Found", %{conn: conn} do
      GeolocationMock
      |> stub(:city, fn @ip -> nil end)

      response =
        conn
        |> get("/city/#{@ip}")
        |> response(404)

      assert response == ""
    end
  end
end
