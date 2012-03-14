class RegistrationsController < ApplicationController

  def agreement
    @user = User.new
  end

  def accept_agreement
    @user = User.new params[:user]
    redirect_to organization_path
  end

  def organization

  end

end
