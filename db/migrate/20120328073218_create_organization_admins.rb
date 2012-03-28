class CreateOrganizationAdmins < ActiveRecord::Migration
  def change
    create_table :organization_admins do |t|
      t.string :email
      t.integer :contact_info_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
