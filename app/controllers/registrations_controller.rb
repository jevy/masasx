class RegistrationsController < ApplicationController

  before_filter :find_user, except: [:agreement, :accept_agreement, :thanks]

  def agreement
    @user = User.new
  end

  def accept_agreement
    @user = User.new params[:user]
    if @user.save
    redirect_to organization_path(@user)
    else
      flash.now[:error] = 'You must accept all the agreements.'
      render :agreement
    end
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

  def update_references
    @user.update_attributes(params[:user])
    redirect_to thanks_path(@user)
  end

  private
  def find_user
    @user = User.find params[:id]
  end

end
