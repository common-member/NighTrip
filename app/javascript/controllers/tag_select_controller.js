import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    const input = document.querySelector('input[name="diagnosis[tag]"]') || document.querySelector('input[name="tag"]')
    const tagName = event.currentTarget.dataset.tagSelectNameValue
    if (input && tagName) {
      input.value = tagName
    }
  }
}
