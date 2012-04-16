class RemoveReferencesLanguageFromOrganizations < ActiveRecord::Migration
  def up
    remove_column :organizations, :references_language
  end

  def down
    add_column :organizations, :references_language, :string
  end
end
