import { Application } from "@hotwired/stimulus"
import TaskController from "controllers/task_controller"

const application = Application.start()
application.register("task", TaskController)

application.debug = false
window.Stimulus = application

export { application }
