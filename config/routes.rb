Rails.application.routes.draw do
  resources :github_payloads, only: [:create]
  root to: "pull_requests#index"
end
