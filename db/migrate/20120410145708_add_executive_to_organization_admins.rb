class AddExecutiveToOrganizationAdmins < ActiveRecord::Migration

  def change
    add_column :organization_admins, :executive, :boolean
  end

end
