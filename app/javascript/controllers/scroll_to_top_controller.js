import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-top"
export default class extends Controller {
    static targets = ["button"]

  connect() {
    this._toggleButtonHandler = this.toggleButton.bind(this)
    window.addEventListener("scroll", this._toggleButtonHandler)
  }


  disconnect() {
    window.removeEventListener("scroll", this._toggleButtonHandler)
  }

  toggleButton() {
    if (window.scrollY > 300) {
      this.buttonTarget.classList.remove("hidden")
    } else {
      this.buttonTarget.classList.add("hidden")
    }
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: "smooth"
    })
  }
}
