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
      @organization.complete_agreement!
      redirect_to organization_path(@organization)
    else
      flash.now[:error] = 'You must accept all the agreements.'
      render :agreement
    end
  end

  def update_organization
    if @organization.update_attributes(params[:organization])
      @organization.complete_organization!
      redirect_to primary_contact_path(@organization)
    else
      flash.now[:error] = @organization.errors.full_messages.to_sentence
      render :organization
    end
  end

  def update_primary_contact
    if @organization.update_attributes(params[:organization])
      @organization.complete_primary_contact!
      redirect_to secondary_contact_path(@organization)
    else
      flash.now[:error] = @organization.errors.messages.values.to_sentence
      render :primary_contact
    end
  end

  def update_secondary_contact
    if @organization.update_attributes(params[:organization])
      @organization.complete_secondary_contact!
      redirect_to references_path(@organization)
    else
      flash.now[:error] = @organization.errors.messages.values.to_sentence
      render :secondary_contact
    end
  end

  def update_references
    if @organization.update_attributes(params[:organization])
      @organization.complete_references!
      redirect_to thanks_path(@organization)
    else
      flash.now[:error] = @organization.errors.messages.values.to_sentence
      render :references
    end
  end

  private
  def find_organization
    @organization = Organization.find params[:id]
  end

end
