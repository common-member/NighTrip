import { Controller } from "@hotwired/stimulus"

// Controller for showing loading spinner during form submission
export default class extends Controller {
  static targets = ["infinity"]

  connect() {
    this.hide()
  }

  show() {
    this.infinityTarget.classList.remove("hidden")
  }

  hide() {
    this.infinityTarget.classList.add("hidden")
  }
}
