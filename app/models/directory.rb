class Directory
  def self.add_organization(organization)
    primary_uuid   = DirectoryApi.create_contact(organization.primary_organization_administrator)
    secondary_uuid = DirectoryApi.create_contact(organization.secondary_organization_administrator)
    authority_uuid = DirectoryApi.create_contact(organization.authority_organization_administrator)
    admin_account = AdminAccount.new(organization.primary_organization_administrator)
    DirectoryApi.create_organization(organization, primary_uuid, secondary_uuid, authority_uuid, admin_account)
  end
end
