class Admin::OrganizationsController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @pending_organizations  = Organization.pending_approval
    @approved_organizations = Organization.approved
    @rejected_organizations = Organization.rejected
  end

  def show
    @organization = Organization.find params[:id]
  end

  def approve
    @organization = Organization.find params[:id]

    @organization.approve!

    redirect_to admin_organizations_path, notice: 'Organization successfully approved!'
  end

  def reject
    @organization = Organization.find params[:id]

    @organization.reject!

    redirect_to admin_organizations_path, notice: 'Organization successfully rejected!'
  end

end
