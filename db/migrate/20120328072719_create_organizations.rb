class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :status
      t.string :name
      t.string :department
      t.string :division
      t.string :sub_division
      t.string :address_line_1
      t.string :telephone
      t.string :website
      t.string :references_language
      t.string :references
      t.string :questions

      t.timestamps
    end
  end
end
