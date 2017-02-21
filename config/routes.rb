Rails.application.routes.draw do
  namespace :api do
    post '/callback' => 'webhook#callback'
  end
end
