import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.hideModal()
  }

  showModal() {
    this.modalTarget.classList.remove("hidden")
  }

  hideModal() {
    this.modalTarget.classList.add("hidden")
  }

  toggleModal() {
    if (this.isOpen()) {
      this.hideModal()
    } else {
      this.showModal()
    }
  }

  isOpen() {
    return !this.modalTarget.classList.contains("hidden")
  }
}
