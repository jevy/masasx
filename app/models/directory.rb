class Directory
  def self.add_organization(organization)
    DirectoryApi.create_organization(organization)
    DirectoryApi.create_contact(organization.primary_organization_administrator)
    DirectoryApi.create_contact(organization.secondary_organization_administrator)
  end
end
