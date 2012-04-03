class Admin::DashboardController < Admin::AdminController
  before_filter :authenticate_masasx_clerk!

  def index
    @pending_approval_organizations = Organization.pending_approval
    @approved_organizations         = Organization.approved
    @rejected_organizations         = Organization.rejected
  end

end
