class AddAddressFieldsToOrganizations < ActiveRecord::Migration
  
  def change
    add_column :organizations, :address_line_2, :string

    add_column :organizations, :city, :string

    add_column :organizations, :state, :string

    add_column :organizations, :country, :string

    add_column :organizations, :postal_code, :string
  end

end
