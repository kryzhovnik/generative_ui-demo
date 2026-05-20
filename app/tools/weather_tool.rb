class WeatherTool < RubyLLM::Tool
  description "Get current weather for a location. The model must supply latitude, longitude, and a display name."

  params do
    number :latitude,  description: "Latitude of the location."
    number :longitude, description: "Longitude of the location."
    string :location,  description: "Display name of the location (e.g. \"Belgrade\")."
  end

  def execute(latitude:, longitude:, location:)
    snapshot = Weather::OpenMeteo.current(latitude: latitude, longitude: longitude, location: location)
    JSON.generate(
      location: snapshot.location,
      temperature: snapshot.temperature_c,
      unit: "c",
      icon: snapshot.icon,
      wind: snapshot.wind_kmh,
      humidity: snapshot.humidity
    )
  rescue Weather::Error
    JSON.generate(error: "weather service unavailable")
  end
end
