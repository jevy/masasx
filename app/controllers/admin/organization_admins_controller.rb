class Admin::OrganizationAdminsController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def edit
    @organization_admin = OrganizationAdmin.find params[:id]
  end

  def update
    @organization_admin = OrganizationAdmin.find params[:id]
    @organization_admin.update_attributes(params[:organization_admin])
    redirect_to admin_organization_path(@organization_admin.organization), notice: 'Organization admin successfully updated!'
  end
end
