import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pendingIcon", "completedIcon", "status"]
  toggle(event) {
    event.preventDefault()
    
    const taskId = this.element.dataset.taskId
    
    fetch(`/tasks/${taskId}/toggle_completed_at`, {
      method: 'POST',
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
          confetti({
            particleCount: 100,
            spread: 70,
            origin: { y: 0.6 }
          })
          this.statusTarget.innerHTML = `
            <span class="inline-flex items-center rounded-full bg-green-100 px-2 py-1 text-xs font-medium text-green-700">Completed</span>
          `;
        } else {
          this.statusTarget.innerHTML = `
            <span class="inline-flex items-center rounded-full bg-blue-100 px-2 py-1 text-xs font-medium text-blue-700">Pending</span>
          `;
        }
      }
    })
  }
}
