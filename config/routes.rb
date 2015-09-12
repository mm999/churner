Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :cards, :subscriptions
  post 'subscriptions/subscribe'
  post 'subscriptions/unsubscribe'
  post 'cards/delete'
  root :to => 'visitors#index'
  get '/about' => 'static_page#about'
  get '/privacy_policy' => 'static_page#privacy_policy'
end
