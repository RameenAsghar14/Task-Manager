// app/assets/javascripts/application.js
import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import "@fortawesome/fontawesome-free/css/all.css"
import { definitionsFromContext } from "stimulus/webpack-helpers"


// Initialize Stimulus
const application = Application.start()
application.debug = false
window.Stimulus = application
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))