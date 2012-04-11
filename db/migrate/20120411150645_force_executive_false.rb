class ForceExecutiveFalse < ActiveRecord::Migration

  def up
    change_column_default :organization_admins, :executive, false
  end

  def down
    change_column_default :organization_admins, :executive, nil
  end

end
