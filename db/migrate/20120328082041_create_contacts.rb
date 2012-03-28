class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :language
      t.string :office_email
      t.string :mobile_email
      t.string :office_phone
      t.string :mobile_phone

      t.integer :contactable_id
      t.string     :contactable_type

      t.timestamps
    end
  end
end
