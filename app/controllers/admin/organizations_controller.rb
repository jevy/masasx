class Admin::OrganizationsController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @organizations = params[:status].present? ? Organization.where(status: params[:status]) : Organization.all
  end

  def show
    @organization = Organization.find params[:id]
  end

  def approve
    @organization = Organization.find params[:id]

    @organization.approve!

    redirect_to admin_dashboard_path, notice: 'Organization successfully approved!'
  end

  def reject
    @organization = Organization.find params[:id]

    @organization.reject!

    redirect_to admin_dashboard_path, notice: 'Organization successfully rejected!'
  end

end
