Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'push#index' 
  post '/payment', to: 'push#payment' 
  get '/callback', to: 'push#callback' 
end
