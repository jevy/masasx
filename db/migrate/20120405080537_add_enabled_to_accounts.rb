class AddEnabledToAccounts < ActiveRecord::Migration

  def change
    add_column :accounts, :enabled, :boolean, default: true
  end

end
