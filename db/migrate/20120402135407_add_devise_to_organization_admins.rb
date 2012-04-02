class AddDeviseToOrganizationAdmins < ActiveRecord::Migration

  def self.up
    #Remove sorcery
    remove_column :organization_admins, :crypted_password
    remove_column :organization_admins, :salt

    change_table(:organization_admins) do |t|
      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :organization_admins, :email,                :unique => true
    add_index :organization_admins, :reset_password_token, :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
