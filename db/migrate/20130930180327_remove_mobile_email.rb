class RemoveMobileEmail < ActiveRecord::Migration
  def change
    remove_column :organization_admins, :mobile_email
    remove_column :organization_admins, :office_email
  end
end
