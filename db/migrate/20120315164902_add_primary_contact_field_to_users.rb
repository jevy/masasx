class AddPrimaryContactFieldToUsers < ActiveRecord::Migration

  def change
    add_column :users, :primary_contact_name, :string
    add_column :users, :primary_contact_title, :string
    add_column :users, :primary_contact_language, :string
    add_column :users, :primary_contact_office_email, :string
    add_column :users, :primary_contact_mobile_email, :string
    add_column :users, :primary_contact_office_phone, :string
    add_column :users, :primary_contact_mobile_phone, :string
  end

end
