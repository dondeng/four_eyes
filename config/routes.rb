FourEyes::Engine.routes.draw do
  resources :actions, only: [:index, :show]
end
