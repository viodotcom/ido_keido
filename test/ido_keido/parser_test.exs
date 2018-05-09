defmodule IdoKeido.ParserTest do
  use ExUnit.Case, async: true

  alias IdoKeido.Parser, as: Subject

  alias IdoKeido.{
    City,
    CityResult,
    Continent,
    Country,
    CountryResult,
    Location
  }

  alias Geolix.Adapter.MMDB2.Record, as: GeolixRecord
  alias Geolix.Adapter.MMDB2.Result, as: GeolixResult

  @ip "134.201.250.155"

  describe "#city/1" do
    setup do
      raw_result = %GeolixResult.City{
        city: %GeolixRecord.City{
          geoname_id: 5_368_361,
          name: "Los Angeles",
          names: %{
            de: "Los Angeles",
            en: "Los Angeles",
            es: "Los Ángeles",
            fr: "Los Angeles",
            ja: "ロサンゼルス",
            "pt-BR": "Los Angeles",
            ru: "Лос-Анджелес",
            "zh-CN": "洛杉矶"
          }
        },
        continent: %GeolixRecord.Continent{
          code: "NA",
          geoname_id: 6_255_149,
          name: "North America",
          names: %{
            de: "Nordamerika",
            en: "North America",
            es: "Norteamérica",
            fr: "Amérique du Nord",
            ja: "北アメリカ",
            "pt-BR": "América do Norte",
            ru: "Северная Америка",
            "zh-CN": "北美洲"
          }
        },
        country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States",
          names: %{
            de: "USA",
            en: "United States",
            es: "Estados Unidos",
            fr: "États-Unis",
            ja: "アメリカ合衆国",
            "pt-BR": "Estados Unidos",
            ru: "США",
            "zh-CN": "美国"
          }
        },
        location: %GeolixRecord.Location{
          accuracy_radius: 5,
          latitude: 34.0544,
          longitude: -118.244,
          metro_code: 803,
          time_zone: "America/Los_Angeles"
        },
        postal: %GeolixRecord.Postal{
          code: "90013"
        },
        registered_country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States",
          names: %{
            de: "USA",
            en: "United States",
            es: "Estados Unidos",
            fr: "États-Unis",
            ja: "アメリカ合衆国",
            "pt-BR": "Estados Unidos",
            ru: "США",
            "zh-CN": "美国"
          }
        },
        represented_country: nil,
        subdivisions: [
          %GeolixRecord.Subdivision{
            geoname_id: 5_332_921,
            iso_code: "CA",
            name: "California",
            names: %{
              de: "Kalifornien",
              en: "California",
              es: "California",
              fr: "Californie",
              ja: "カリフォルニア州",
              "pt-BR": "Califórnia",
              ru: "Калифорния",
              "zh-CN": "加利福尼亚州"
            }
          }
        ],
        traits: %{ip_address: {134, 201, 250, 155}}
      }

      parsed_result = %CityResult{
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

      {:ok, raw_result: raw_result, parsed_result: parsed_result}
    end

    test "returns parsed city result", %{raw_result: raw_result, parsed_result: parsed_result} do
      assert Subject.city(raw_result, @ip) == parsed_result
    end
  end

  describe "#country/1" do
    setup do
      raw_result = %GeolixResult.Country{
        continent: %GeolixRecord.Continent{
          code: "NA",
          geoname_id: 6_255_149,
          name: "North America",
          names: %{
            de: "Nordamerika",
            en: "North America",
            es: "Norteamérica",
            fr: "Amérique du Nord",
            ja: "北アメリカ",
            "pt-BR": "América do Norte",
            ru: "Северная Америка",
            "zh-CN": "北美洲"
          }
        },
        country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States",
          names: %{
            de: "USA",
            en: "United States",
            es: "Estados Unidos",
            fr: "États-Unis",
            ja: "アメリカ合衆国",
            "pt-BR": "Estados Unidos",
            ru: "США",
            "zh-CN": "美国"
          }
        },
        registered_country: %GeolixRecord.Country{
          geoname_id: 6_252_001,
          iso_code: "US",
          name: "United States",
          names: %{
            de: "USA",
            en: "United States",
            es: "Estados Unidos",
            fr: "États-Unis",
            ja: "アメリカ合衆国",
            "pt-BR": "Estados Unidos",
            ru: "США",
            "zh-CN": "美国"
          }
        },
        represented_country: nil,
        traits: %{ip_address: {134, 201, 250, 155}}
      }

      parsed_result = %CountryResult{
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

      {:ok, raw_result: raw_result, parsed_result: parsed_result}
    end

    test "returns parsed country result", %{raw_result: raw_result, parsed_result: parsed_result} do
      assert Subject.country(raw_result, @ip) == parsed_result
    end
  end
end
