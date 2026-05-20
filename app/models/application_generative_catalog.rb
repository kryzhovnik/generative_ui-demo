class ApplicationGenerativeCatalog < GenerativeUI::Catalog
  component "Container" do
    desc "Layout container. Arranges children horizontally (row) or vertically (stack). Use to compose cards, pickers, multi-day plans."
    attributes do
      string :orientation, enum: %w[horizontal vertical], description: "Layout direction."
      many_components :children
    end
  end

  component "Weather" do
    desc "Weather card. Use `temperature` for current weather, or `temperature_min`/`temperature_max` + `date` for a forecast day."
    attributes do
      string :location, description: "Display name (e.g. \"Belgrade\")."
      number :temperature, description: "Current temperature in the chosen unit.", required: false
      string :unit, enum: %w[c f], required: false
      string :icon, enum: %w[sunny cloudy rainy snowy stormy], required: false
      string :date, description: "ISO date (YYYY-MM-DD) for forecast-day cards.", required: false
      number :temperature_min, required: false
      number :temperature_max, required: false
      number :wind, required: false
      number :humidity, required: false
    end
  end

  component "Heading" do
    desc "Section heading. Use level 1 for top-level titles, level 2 for sub-sections."
    attributes do
      string  :text
      integer :level, minimum: 1, maximum: 3, required: false
    end
  end

  component "QuickReply" do
    desc "Clickable reply button. Clicking it submits its `value` (or `label`, if no value) as the next user message. Use for disambiguation pickers and suggested follow-ups."
    attributes do
      string :label, description: "Text shown on the button."
      string :value, description: "What gets sent as the next user message. Defaults to label.", required: false
    end
  end

  component "Checklist" do
    desc "Bullet list of short items. Use for packing lists, what-to-wear advice, step recipes, or similar enumerations."
    attributes do
      array  :items, of: :string, description: "List of strings to display as bullets."
      string :title, required: false
    end
  end
end
