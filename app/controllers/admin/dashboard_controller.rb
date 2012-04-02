class Admin::DashboardController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @pending_approval_organizations = Organization.pending_approval
  end

end
