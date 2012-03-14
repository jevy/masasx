class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organization_name, :string

    add_column :users, :department, :string

    add_column :users, :division, :string

    add_column :users, :sub_division, :string

    add_column :users, :address_line_1, :string

    add_column :users, :telephone, :string

    add_column :users, :website, :string

  end
end
