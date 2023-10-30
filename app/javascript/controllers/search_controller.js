import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["params"]
  connect() {
    const value = this.paramsTarget.value
    console.log(value)
  }
  // fetch(`/books/search?search=${value}`, {
  //   headers: {
  //     "Content-Type": "application/json",
  //   }
  // })
  // .then((response) => response.text())
  // .then(res => {
  // })
}