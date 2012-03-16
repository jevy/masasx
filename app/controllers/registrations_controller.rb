class RegistrationsController < ApplicationController

  before_filter :find_user, except: [:agreement, :accept_agreement]

  def agreement
    @user = User.new
  end

  def accept_agreement
    @user = User.new params[:user]
    @user.save
    redirect_to organization_path(@user)
  end

  def update_organization
    @user.update_attributes(params[:user])
    redirect_to primary_contact_path(@user)
  end

  def update_primary_contact
    @user.update_attributes(params[:user])
    redirect_to secondary_contact_path(@user)
  end

  def update_secondary_contact
    @user.update_attributes(params[:user])
    redirect_to references_path(@user)
  end

  private
  def find_user
    @user = User.find params[:id]
  end

end
