class PrimaryContactCountryState < ActiveRecord::Migration
  def change
    remove_column :organization_admins, :country
    add_column :organization_admins, :country, :string, :default => ""
    remove_column :organization_admins, :state
    add_column :organization_admins, :state, :string, :default => ""
  end
end
