class WelcomeController < ApplicationController
  def index
  end

  def subregion_options
    render partial: 'registrations/subregion_select'
  end

  def primary_subregion_options
    render partial: 'registrations/subregion_select_primary'
  end

  def secondary_subregion_options
    render partial: 'registrations/subregion_select_secondary'
  end

  def authority_subregion_options
    render partial: 'registrations/subregion_select_authority'
  end
end
