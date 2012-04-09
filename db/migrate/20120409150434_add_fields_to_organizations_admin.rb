class AddFieldsToOrganizationsAdmin < ActiveRecord::Migration
  def change
    add_column(:organization_admins, :name, :string)
    add_column(:organization_admins, :title, :string)
    add_column(:organization_admins, :language, :string)
    add_column(:organization_admins, :office_email, :string)
    add_column(:organization_admins, :mobile_email, :string)
    add_column(:organization_admins, :office_phone, :string)
    add_column(:organization_admins, :mobile_phone, :string)
  end
end
