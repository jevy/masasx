Masasx::Application.routes.draw do
  get '/registration' => 'registrations#agreement'
  post '/accept_agreement' => 'registrations#accept_agreement'

  get '/organization/:id' => 'registrations#organization', as: :organization
  put '/update_organization/:id' => 'registrations#update_organization', as: :update_organization

  get '/contact/:id' => 'registrations#contact', as: :contact

  root to: 'registrations#agreement'
end
