class ChangeReferencesAndQuestionsToOrganizations < ActiveRecord::Migration

  def up
    change_column(:organizations, :references, :text)
    change_column(:organizations, :questions, :text)
  end

  def down
    change_column(:organizations, :references, :string)
    change_column(:organizations, :questions, :string)
  end

end
