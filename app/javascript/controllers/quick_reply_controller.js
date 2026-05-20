import { Controller } from "@hotwired/stimulus"

// Fills the new-message textarea with this button's value and submits the form.
export default class extends Controller {
  static values = { payload: String }

  send(event) {
    event.preventDefault()
    const form = document.querySelector("#new_chat,#new_message")
    if (!form) return
    const textarea = form.querySelector("textarea")
    if (textarea) textarea.value = this.payloadValue
    form.requestSubmit()
  }
}
