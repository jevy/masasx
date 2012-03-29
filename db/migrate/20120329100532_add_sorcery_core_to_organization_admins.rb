class AddSorceryCoreToOrganizationAdmins < ActiveRecord::Migration

  def change
    add_column :organization_admins, :crypted_password, :string, default: nil
    add_column :organization_admins, :salt,             :string, default: nil
  end

end
