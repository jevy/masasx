class WelcomeController < ApplicationController
  def index
  end

  def subregion_options
    render partial: 'registrations/subregion_select'
  end

  def primary_subregion_options
    render partial: 'registrations/subregion_select_primary'
  end
end
