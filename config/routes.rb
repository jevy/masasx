Masasx::Application.routes.draw do
  get '/registration' => 'registrations#new'

  root to: 'registrations#new'
end
