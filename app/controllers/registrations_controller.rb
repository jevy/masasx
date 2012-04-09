class RegistrationsController < ApplicationController

  before_filter :find_organization, except: :start
  before_filter :assign_current_step, except: :pending_approval

  def start
    @organization = Organization.new
    @organization.save
    render current_step
  end

  def next_step
    if @organization.update_attributes(params[:organization])
      @organization.next!
      redirect_to action: @organization.status, id: @organization
    else
      flash.now[:error] = 'Please review your data'
      render current_step
    end
  end

  def previous_step
    @organization.previous!
    render current_step
  end

  def primary_contact
    @organization.build_primary_organization_administrator(role: 'Primary') unless @organization.primary_organization_administrator
  end

  def secondary_contact
    @organization.build_secondary_organization_administrator(role: 'Secondary') unless @organization.secondary_organization_administrator
  end

  private
  def current_step
    @organization.status_name
  end

  def find_organization
    @organization = Organization.find params[:id]
  end

  def assign_current_step
   @current_step = find_current_step
  end

  def find_current_step
    return 1 unless @organization
    steps = [:agreement, :organization, :primary_contact, :secondary_contact, :references]
    steps.find_index(current_step)+1
  end

end
