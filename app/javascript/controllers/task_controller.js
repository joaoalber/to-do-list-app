import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pendingIcon", "completedIcon", "status"]

  toggle(event) {
    event.preventDefault()
    
    const taskId = this.element.dataset.taskId
    
    fetch(`/tasks/${taskId}`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.pendingIconTarget.classList.toggle('hidden')
        this.completedIconTarget.classList.toggle('hidden')

        if (data.completed_at != null) {
          this.statusTarget.innerText = 'Completed'
          confetti({
            particleCount: 100,
            spread: 70,
            origin: { y: 0.6 }
          })
        } else {
          this.statusTarget.innerText = 'Pending'
        }
      }
    })
  }
}
