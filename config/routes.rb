Rails.application.routes.draw do
  resources :profiles

  post 'profiles/:id/update_informations' => 'profiles#update_informations'

  root 'profiles#index'
end
