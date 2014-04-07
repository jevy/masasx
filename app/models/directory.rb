class Directory
  def self.add_organization(organization)
    DirectoryApi.create_contact(organization.primary_organization_administrator)
    DirectoryApi.create_contact(organization.secondary_organization_administrator)
    DirectoryApi.create_organization_contact(organization.as_contact)
    DirectoryApi.create_organization(organization,
                                     organization.as_contact,
                                     organization.primary_organization_administrator,
                                     organization.secondary_organization_administrator)
  rescue Faraday::Error::ClientError
    DirectoryApi.delete_contact(organization.primary_organization_administrator) rescue nil
    DirectoryApi.delete_contact(organization.secondary_organization_administrator) rescue nil
    DirectoryApi.delete_contact(organization.as_contact) rescue nil
    raise
  end
end
