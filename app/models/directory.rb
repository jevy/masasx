class Directory
  def self.add_organization(organization)
    DirectoryApi.create_contact(organization.primary_organization_administrator)
    DirectoryApi.create_contact(organization.secondary_organization_administrator)

    if organization.has_primary_executive?
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.primary_organization_administrator)
    elsif organization.has_secondary_executive?
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.secondary_organization_administrator)
    else
      DirectoryApi.create_contact(organization.authority_organization_administrator)
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.authority_organization_administrator)
    end

  rescue DirectoryApiException => e
    DirectoryApi.delete_contact(organization.primary_organization_administrator)
    DirectoryApi.delete_contact(organization.secondary_organization_administrator)
    DirectoryApi.delete_contact(organization.authority_organization_administrator)
    raise DirectoryApiException.new e.message
  end
end
