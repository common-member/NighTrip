import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "progress"]

  connect() {
    this.currentStep = 0
    this.showStep()
    this.updateProgress()
  }

  showStep() {
    this.stepTargets.forEach((el, index) => {
      el.style.display = index === this.currentStep ? "block" : "none"
    })
  }

  updateProgress() {
    const steps = this.progressTarget?.querySelectorAll(".step") || []
    steps.forEach((el, index) => {
      el.classList.toggle("step-primary", index <= this.currentStep)
    })
  }

  next() {
    if (!this.validateStep(this.currentStep)) return

    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++
      this.showStep()
      this.updateProgress()
    }
  }

  back() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.showStep()
      this.updateProgress()
    }
  }

  validateStep(stepIndex) {
    const step = this.stepTargets[stepIndex]
    const inputs = step.querySelectorAll("input[required], select[required]")

    for (const input of inputs) {
      if (input.type === "radio") {
        const name = input.name
        const checked = step.querySelector(`input[name="${name}"]:checked`)
        if (!checked) {
          alert("必須項目を選択してください。")
          return false
        }
      } else if (!input.value.trim()) {
        alert("必須項目を入力してください。")
        return false
      }
    }

    return true
  }
}
