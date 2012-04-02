Masasx::Application.routes.draw do

  devise_for :masasx_clerks

  devise_for :organization_admins

  get '/registration' => 'registrations#agreement'
  post '/accept_agreement' => 'registrations#accept_agreement', as: :accept_agreement

  get '/organization/:id' => 'registrations#organization', as: :organization
  put '/update_organization/:id' => 'registrations#update_organization', as: :update_organization

  get '/primary_contact/:id' => 'registrations#primary_contact', as: :primary_contact
  put '/primary_contact/:id' => 'registrations#update_primary_contact', as: :update_primary_contact

  get '/secondary_contact/:id' => 'registrations#secondary_contact', as: :secondary_contact
  put '/secondary_contact/:id' => 'registrations#update_secondary_contact', as: :update_secondary_contact

  get '/references/:id' => 'registrations#references', as: :references
  put '/update_references/:id' => 'registrations#update_references', as: :update_references

  get '/thanks' => 'registrations#thanks', as: :thanks

  namespace :admin do
    resources :accounts do
      member do
        get 'permissions'
        put 'update_permissions'
      end
    end
    get '/dashboard' => 'dashboard#index', as: :dashboard
    root to: 'home#index'
  end

  root to: 'registrations#agreement'
end
