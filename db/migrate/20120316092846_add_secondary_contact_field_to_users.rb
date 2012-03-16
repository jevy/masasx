class AddSecondaryContactFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secondary_contact_name, :string
    add_column :users, :secondary_contact_title, :string
    add_column :users, :secondary_contact_language, :string
    add_column :users, :secondary_contact_office_email, :string
    add_column :users, :secondary_contact_mobile_email, :string
    add_column :users, :secondary_contact_office_phone, :string
    add_column :users, :secondary_contact_mobile_phone, :string
  end
end
