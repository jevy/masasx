class UpdateStatusToNewForPendingOrganizations < ActiveRecord::Migration
  class Organization < ActiveRecord::Base; end

  def up
    Organization.where(status: "pending_approval").update_all(status: "new")
  end

  def down
    Organization.where(status: "new").update_all(status: "pending_approval")
  end
end
