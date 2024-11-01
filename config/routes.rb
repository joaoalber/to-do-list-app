Rails.application.routes.draw do
  root to: "tasks#index"

  devise_for :users

  resources :tasks, except: %i[show] do
    member do
      post "toggle_completed_at"
    end

    collection do
      post "archive_tasks"
    end
  end
end
