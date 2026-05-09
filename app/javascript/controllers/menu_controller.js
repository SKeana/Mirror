import { Controller } from "@hotwired/stimulus"

// Toggleable dropdown menu. Click the trigger to open, click outside or
// press Escape to close.
export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.boundOutsideClick = this.outsideClick.bind(this)
    this.boundEscape = this.escape.bind(this)
    document.addEventListener("click", this.boundOutsideClick)
    document.addEventListener("keydown", this.boundEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.boundOutsideClick)
    document.removeEventListener("keydown", this.boundEscape)
  }

  toggle(event) {
    event.stopPropagation()
    this.panelTarget.hidden = !this.panelTarget.hidden
  }

  outsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.panelTarget.hidden = true
    }
  }

  escape(event) {
    if (event.key === "Escape") this.panelTarget.hidden = true
  }
}
