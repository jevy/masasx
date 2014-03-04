class DefaultCountry < ActiveRecord::Migration
  def change
    remove_column :organizations, :country
    add_column :organizations, :country, :string, :default => ""
    remove_column :organizations, :state
    add_column :organizations, :state, :string, :default => ""
  end
end
