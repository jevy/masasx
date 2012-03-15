Masasx::Application.routes.draw do
  get '/registration' => 'registrations#agreement'
  post '/accept_agreement' => 'registrations#accept_agreement'

  get '/organization/:id' => 'registrations#organization', as: :organization
  put '/update_organization/:id' => 'registrations#update_organization', as: :update_organization

  get '/primary_contact/:id' => 'registrations#primary_contact', as: :primary_contact
  put '/primary_contact/:id' => 'registrations#update_primary_contact', as: :update_primary_contact

  get '/secondary_contact/:id' => 'registrations#secondary_contact', as: :secondary_contact

  root to: 'registrations#agreement'
end
