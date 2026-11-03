import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["count"]

  connect() {
    this.update()
  }

  update() {
    this.countTarget.textContent = this.element.value.length
  }

}