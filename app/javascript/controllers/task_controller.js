import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Task controller connected");
  }

  markCompleted(event) {
    event.preventDefault();
    console.log("Mark completed action triggered");
  }
}
