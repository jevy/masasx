class AddLastname < ActiveRecord::Migration
  def change
    add_column :organization_admins, :first_name, :string
    rename_column :organization_admins, :name, :last_name
  end
end
