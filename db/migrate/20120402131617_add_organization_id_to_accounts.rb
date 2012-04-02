class AddOrganizationIdToAccounts < ActiveRecord::Migration

  def change
    add_column :accounts, :organization_id, :integer
  end

end
