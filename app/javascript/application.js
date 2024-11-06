// app/assets/javascripts/application.js
import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import "@fortawesome/fontawesome-free/css/all.css"

// Initialize Stimulus
const application = Application.start()
application.debug = false
window.Stimulus = application

