Masasx::Application.routes.draw do
  get '/registration' => 'registrations#agreement'
  post '/accept_agreement' => 'registrations#accept_agreement'

  get '/organization' => 'registrations#organization'

  root to: 'registrations#agreement'
end
