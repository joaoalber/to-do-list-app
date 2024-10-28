// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function toggleElement(elementId) {
  var element = document.getElementById(elementId);
  if (element) {
    element.classList.toggle('hidden');
  }
}

window.toggleElement = toggleElement;
