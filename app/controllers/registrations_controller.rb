class RegistrationsController < ApplicationController

  before_filter :find_organization, except: :start

  def start
    @organization = Organization.new
    @organization.save
    render current_step
  end

  def next_step
    if @organization.update_attributes(params[:organization])
      @organization.next!
      MasasxClerk.find_each { |masasx_clerk| MasasxClerkMailer.new_organization(masasx_clerk, @organization).deliver } if @organization.status == "new"
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

end
