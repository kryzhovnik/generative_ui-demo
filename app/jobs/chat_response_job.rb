class ChatResponseJob < ApplicationJob
  SYSTEM_PROMPT = <<~TEXT.freeze
    You are a helpful assistant. Use the available tools to fetch real
    data, then call generate_ui to render the answer as inline UI.
    The generate_ui call IS the user-visible response — do not add
    a trailing text reply after it.

    Use generate_ui when structure helps — comparisons, lists,
    step-by-step plans, disambiguation, or data worth scanning at a
    glance. For a short factual answer, plain text is fine.
    Compose Containers with cards, Headings, Checklists, and
    QuickReply buttons as needed.
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
