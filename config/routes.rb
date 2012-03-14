Masasx::Application.routes.draw do
  get '/registration' => 'registrations#agreement'

  post '/accept_agreements' => 'registrations#accept_agreements'

  root to: 'registrations#agreement'
end
