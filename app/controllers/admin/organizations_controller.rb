class Admin::OrganizationsController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @organizations = params[:status].present? ? Organization.where(status: params[:status]) : Organization.all
  end

end
