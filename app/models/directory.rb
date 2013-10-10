class Directory
  def self.add_organization(organization)
    admin_account = AdminAccount.new(organization.primary_organization_administrator)

    primary_uuid   = DirectoryApi.create_contact(organization.primary_organization_administrator)
    organization.primary_organization_administrator.update_attributes({uuid: primary_uuid})

    secondary_uuid = DirectoryApi.create_contact(organization.secondary_organization_administrator)
    organization.secondary_organization_administrator.update_attributes({uuid: secondary_uuid})

    if organization.has_primary_executive?
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.primary_organization_administrator, admin_account)
    elsif organization.has_secondary_executive?
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.secondary_organization_administrator, admin_account)
    else
      authority_uuid = DirectoryApi.create_contact(organization.authority_organization_administrator)
      organization.authority_organization_administrator.update_attributes({uuid: authority_uuid})
      DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.authority_organization_administrator, admin_account)
    end

  rescue DirectoryApiException => e
    DirectoryApi.delete_contact(organization.primary_organization_administrator) if organization.primary_organization_administrator.uuid
    DirectoryApi.delete_contact(organization.secondary_organization_administrator) if organization.secondary_organization_administrator.uuid
    DirectoryApi.delete_contact(organization.authority_organization_administrator) if organization.authority_organization_administrator && organization.authority_organization_administrator.uuid
    raise DirectoryApiException.new e.message
  end
end
