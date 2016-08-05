Rails.application.routes.draw do
  resources :users
  resource :session
  resources :subs do
    resources :posts
  end
  
end
