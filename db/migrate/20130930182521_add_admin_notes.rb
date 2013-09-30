class AddAdminNotes < ActiveRecord::Migration
  def change
    add_column :organizations, :admin_notes, :text
  end
end
