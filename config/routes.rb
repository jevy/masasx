Masasx::Application.routes.draw do
  get '/registration' => 'registrations#agreement'

  root to: 'registrations#agreement'
end
