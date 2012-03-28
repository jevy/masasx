class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :access_code
      t.string :permissions_store

      t.timestamps
    end
  end
end
