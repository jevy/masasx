class Directory
  def self.add_organization(organization)
    DirectoryApi.create_contact(organization.primary_organization_administrator)
    DirectoryApi.create_contact(organization.secondary_organization_administrator)
    DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator)

  rescue DirectoryApiException => e
    DirectoryApi.delete_contact(organization.primary_organization_administrator)
    DirectoryApi.delete_contact(organization.secondary_organization_administrator)
    raise DirectoryApiException.new e.message
  end
end
