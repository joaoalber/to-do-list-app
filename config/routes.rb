Rails.application.routes.draw do
  resources :tasks, except: %i[show] do
    member do
      post "toggle_completed_at"
    end

    collection do
      post "archive_tasks"
    end
  end
end
