class ContactUuid < ActiveRecord::Migration
  def change
    add_column :organization_admins, :uuid, :string
  end
end
