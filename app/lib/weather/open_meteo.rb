require "faraday"
require "json"

module Weather
  class OpenMeteo
    ENDPOINT = "https://api.open-meteo.com/v1/forecast"

    Current = Data.define(:location, :temperature_c, :humidity, :wind_kmh, :icon)
    Day     = Data.define(:date, :temperature_min_c, :temperature_max_c, :icon, :precipitation_mm)

    def self.current(latitude:, longitude:, location:)
      new.current(latitude: latitude, longitude: longitude, location: location)
    end

    def self.daily(latitude:, longitude:, location:, days: 3)
      new.daily(latitude: latitude, longitude: longitude, location: location, days: days)
    end

    def current(latitude:, longitude:, location:)
      body = get(
        latitude: latitude,
        longitude: longitude,
        current: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"
      )
      c = body.fetch("current")
      Current.new(
        location: location,
        temperature_c: c.fetch("temperature_2m").round,
        humidity: c.fetch("relative_humidity_2m"),
        wind_kmh: c.fetch("wind_speed_10m"),
        icon: WeatherCode.icon_for(c.fetch("weather_code"))
      )
    end

    def daily(latitude:, longitude:, location:, days: 3)
      body = get(
        latitude: latitude,
        longitude: longitude,
        daily: "temperature_2m_max,temperature_2m_min,weather_code,precipitation_sum",
        forecast_days: days
      )
      d = body.fetch("daily")
      d.fetch("time").each_with_index.map do |date, i|
        Day.new(
          date: date,
          temperature_min_c: d.fetch("temperature_2m_min")[i].round,
          temperature_max_c: d.fetch("temperature_2m_max")[i].round,
          icon: WeatherCode.icon_for(d.fetch("weather_code")[i]),
          precipitation_mm: d.fetch("precipitation_sum")[i]
        )
      end
    end

    private

    def get(params)
      response = Faraday.get(ENDPOINT, params)
      raise Error, "open-meteo returned #{response.status}" unless response.success?
      JSON.parse(response.body)
    end
  end
end
