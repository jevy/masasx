class RemoveMobileAndTitle < ActiveRecord::Migration
  def change
    remove_column :organization_admins, :mobile_phone
    remove_column :organization_admins, :title
  end
end
