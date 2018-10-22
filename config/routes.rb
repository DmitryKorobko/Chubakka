Rails.application.routes.draw do
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'signin', to: 'static_pages#sign_in'
  get 'signup', to: 'static_pages#sign_up'

  root 'static_pages#home'
end
