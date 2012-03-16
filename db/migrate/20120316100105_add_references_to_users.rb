class AddReferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :references_language, :string
    add_column :users, :references, :string
    add_column :users, :questions, :string
  end
end
