class ChatResponseJob < ApplicationJob
  SYSTEM_PROMPT = <<~TEXT.freeze
    You are a helpful weather advisor. When the user asks about weather,
    use the WeatherTool to fetch real data, then call generate_ui to
    present the answer as inline UI. After calling generate_ui,
    do not add a final text answer — the tool call itself
    is the user-visible response.

    Prefer rich UI over plain text:
    - one location, current weather → Weather card
    - comparison → horizontal Container of Weather cards
    - ambiguous city → vertical Container of QuickReply buttons
    - multi-day plan → vertical Container of day blocks, each a vertical
      Container of Heading + Weather + Checklist
    - outfit advice → vertical Container of Weather + Checklist
  TEXT

  def perform(chat_id, content)
    ui_tool = GenerativeUI::Tool.new

    chat = Chat.find(chat_id)
      .with_instructions(SYSTEM_PROMPT)
      .with_tools(WeatherTool)
      .with_tools(ui_tool)


    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.last
        message.broadcast_append_chunk(chunk.content)
      end
    end
  end
end
