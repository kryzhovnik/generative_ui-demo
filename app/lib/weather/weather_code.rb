module Weather
  module WeatherCode
    ICONS = {
      "sunny"  => [ 0, 1 ],
      "cloudy" => [ 2, 3, 45, 48 ],
      "rainy"  => (51..67).to_a + (80..82).to_a,
      "snowy"  => (71..77).to_a + (85..86).to_a,
      "stormy" => (95..99).to_a
    }.freeze

    def self.icon_for(code)
      return "sunny" if code.nil?

      ICONS.find { |_, codes| codes.include?(code) }&.first || "sunny"
    end
  end
end
