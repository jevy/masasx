class AdminSessionsController < ApplicationController

  def new
    @organization_admin = OrganizationAdmin.new
  end

  def create
    if @organization_admin = login(params[:organization_admin][:email], params[:organization_admin][:password])
      redirect_back_or_to admin_root_path, notice: 'Login successful.'
    else
      flash[:error] = 'Login failed'
      redirect_to action: :new
    end
  end

  def destroy
  end

end
