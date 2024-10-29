import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-review"
export default class extends Controller {
  static targets = ["form", "list", "btn"];
  connect() {
    console.log("im connected!");
  }

  create(event) {
    event.preventDefault();
    fetch(this.formTarget.action, {
      method: "POST",
      headers: { Accept: "text/plain" },
      body: new FormData(this.formTarget),
    })
      .then((response) => response.text())
      .then((data) => {
        // console.log(data);
        this.listTarget.insertAdjacentHTML("beforeend", data);
        this.formTarget.reset();
        this.btnTarget.click();
      });
  }
}
