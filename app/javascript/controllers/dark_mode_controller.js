import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (localStorage.getItem("darkMode") === "true") {
      document.documentElement.classList.add("dark")
    }
  }

  toggle() {
    const html = document.documentElement
    html.classList.toggle("dark")
    localStorage.setItem("darkMode", html.classList.contains("dark"))
  }
}
