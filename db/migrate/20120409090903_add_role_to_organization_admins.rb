class AddRoleToOrganizationAdmins < ActiveRecord::Migration

  def change
    add_column :organization_admins, :role, :string
  end

end
