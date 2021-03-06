Masasx::Application.routes.draw do

  devise_for :masasx_clerks

  devise_for :organization_admins

  get '/registration'          => 'registrations#start'
  get '/organization/:id'      => 'registrations#organization'
  get '/primary_contact/:id'   => 'registrations#primary_contact'
  get '/secondary_contact/:id' => 'registrations#secondary_contact'
  get '/references/:id'        => 'registrations#references'
  get '/new/:id'               => 'registrations#new'
  put '/next_step/:id'         => 'registrations#next_step',     as: :next_step
  get '/previous_step/:id'     => 'registrations#previous_step', as: :previous_step

  namespace :admin do
    resources :organizations do
      member  do
        get 'mark_as_new'
        get 'mark_as_in_progress'
        get 'mark_as_on_hold'
        get 'approve'
        get 'reject'
      end
    end
    resources :organization_admins, only: [:update, :edit, :show]
    resources :accounts do
      member do
        get 'permissions'
        get 'toggle_enabled'
        put 'update_permissions'
      end
    end
    get '/dashboard' => 'dashboard#index', as: :dashboard
    root to: 'accounts#index',       constraints: lambda { |request| request.session['warden.user.organization_admin.key'].present? }
    root to: 'organizations#index',  constraints: lambda { |request| request.session['warden.user.masasx_clerk.key'].present? }
    root to: 'home#index'
  end

  root to: 'welcome#index'
  match '/admin/organizations' => 'organizations#index', as: :masasx_clerk_root
  match '/admin/accounts'      => 'accounts#index',      as: :organization_admin_root
end
