# generative_ui-demo

A Rails demo of the [`generative_ui`](https://github.com/kryzhovnik/generative_ui) gem: an LLM-driven weather advisor that answers with rich inline UI (cards, checklists, quick replies) instead of plain text.

## Try it in the chat

The assistant maps your question to a UI shape. A few prompts to try:

- **Current weather** → single Weather card
  - *"What's the weather in Lisbon right now?"*
- **Comparison** → row of Weather cards
  - *"Compare today's weather in Berlin, Paris, and Madrid."*
- **Ambiguous city** → QuickReply buttons to disambiguate
  - *"How's the weather in Springfield?"*
- **Multi-day plan** → stacked day blocks with Heading + Weather + Checklist
  - *"Plan a 3-day trip to Reykjavík next week."*
- **Outfit advice** → Weather card + packing Checklist
  - *"What should I wear in Tokyo tomorrow?"*

## Running locally

```bash
bin/setup
bin/dev
```

Set `OPENAI_API_KEY` in the environment, or add `openai_api_key` to Rails credentials. The key is wired up in `config/initializers/ruby_llm.rb`.

The `generative_ui` gem is pulled from the `main` branch on GitHub in the `Gemfile`; `Gemfile.lock` pins the exact commit.

The default model is `gpt-5.6-luna` (see `config/initializers/ruby_llm.rb`). Run `bin/rails ruby_llm:load_models` after setup to fill the model registry.
