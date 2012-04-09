class DropContacts < ActiveRecord::Migration

  def up
    drop_table(:contacts)
  end

  def down
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :language
      t.string :office_email
      t.string :mobile_email
      t.string :office_phone
      t.string :mobile_phone

      t.integer :contactable_id
      t.string  :contactable_type

      t.timestamps
    end
  end

end
