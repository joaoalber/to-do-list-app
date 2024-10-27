// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function completeTask(iconId) {
  const checkIcon = document.getElementById(`${iconId}-pending-icon`);
  const completedIcon = document.getElementById(`${iconId}-completed-icon`);
  const statusText = document.getElementById(`${iconId}-status`);

  checkIcon.classList.toggle('hidden');
  completedIcon.classList.toggle('hidden');

  if (statusText.innerText === 'Completed') {
    statusText.innerText = 'Pending';
  } else {
    statusText.innerText = 'Completed';
  }
  
  confetti({
    particleCount: 100,
    spread: 70,
    origin: { y: 0.6 },
  });
}

window.completeTask = completeTask;