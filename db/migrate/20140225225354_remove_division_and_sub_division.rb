class RemoveDivisionAndSubDivision < ActiveRecord::Migration
  def change
    remove_column :organizations, :division
    remove_column :organizations, :sub_division
  end
end
