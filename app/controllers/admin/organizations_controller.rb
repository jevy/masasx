class Admin::OrganizationsController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @organizations = params[:status].present? ? Organization.where(status: params[:status]) : Organization.all
  end

  def approve
    @organization = Organization.find params[:id]

    @organization.approve!

    redirect_to admin_organizations_path(status: 'completed'), notice: 'Organization successfully approved!'
  end

end
