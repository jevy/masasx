class RemoveExecutiveFromOrganizationAdmins < ActiveRecord::Migration
  def up
    remove_column :organization_admins, :executive
      end

  def down
    add_column :organization_admins, :executive, :boolean
  end
end
