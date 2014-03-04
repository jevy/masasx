class WelcomeController < ApplicationController
  def index
  end

  def subregion_options
    render partial: 'registrations/subregion_select'
  end
end
