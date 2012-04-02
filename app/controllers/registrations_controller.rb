class RegistrationsController < ApplicationController

  before_filter :find_organization, except: [:agreement, :accept_agreement, :thanks]

  def agreement
    @organization = Organization.new
  end

  def primary_contact
    organization_administrator = OrganizationAdmin.new
    @organization.build_primary_organization_administrator.build_contact_info
  end

  def secondary_contact
    organization_administrator = OrganizationAdmin.new
    @organization.build_secondary_organization_administrator.build_contact_info
  end

  def accept_agreement
    @organization = Organization.new params[:organization]
    if @organization.save
    redirect_to organization_path(@organization)
    else
      flash.now[:error] = 'You must accept all the agreements.'
      render :agreement
    end
  end

  def update_organization
    @organization.update_attributes(params[:organization])
    redirect_to primary_contact_path(@organization)
  end

  def update_primary_contact
    @organization.update_attributes(params[:organization])
    redirect_to secondary_contact_path(@organization)
  end

  def update_secondary_contact
    @organization.update_attributes(params[:organization])
    redirect_to references_path(@organization)
  end

  def update_references
    @organization.update_attributes(params[:organization])
    redirect_to thanks_path(@organization)
  end

  private
  def find_organization
    @organization = Organization.find params[:id]
  end

end
