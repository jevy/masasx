class AddAddressFieldsToOrganizationAdmins < ActiveRecord::Migration
  def change
    add_column :organization_admins, :address_line_1, :string

    add_column :organization_admins, :address_line_2, :string

    add_column :organization_admins, :city, :string

    add_column :organization_admins, :state, :string

    add_column :organization_admins, :country, :string

    add_column :organization_admins, :postal_code, :string
  end
end
