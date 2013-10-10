class Directory
  def self.add_organization(organization)
    admin_account = AdminAccount.new(organization.primary_organization_administrator)

    begin
      primary_uuid   = DirectoryApi.create_contact(organization.primary_organization_administrator)
      organization.primary_organization_administrator.update_attributes({uuid: primary_uuid})
    rescue DirectoryApiException => e
      raise DirectoryApiException.new e.message
    end

    begin
      secondary_uuid = DirectoryApi.create_contact(organization.secondary_organization_administrator)
      organization.secondary_organization_administrator.update_attributes({uuid: secondary_uuid})
    rescue DirectoryApiException => e
      DirectoryApi.delete_contact(organization.primary_organization_administrator)
      raise DirectoryApiException.new e.message
    end

      if organization.has_primary_executive?
        begin
          DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.primary_organization_administrator, admin_account)
        rescue DirectoryApiException => e
          DirectoryApi.delete_contact(organization.primary_organization_administrator)
          DirectoryApi.delete_contact(organization.secondary_organization_administrator)
          raise DirectoryApiException.new e.message
        end
      elsif organization.has_secondary_executive?
        begin
          DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.secondary_organization_administrator, admin_account)
        rescue DirectoryApiException => e
          DirectoryApi.delete_contact(organization.primary_organization_administrator)
          DirectoryApi.delete_contact(organization.secondary_organization_administrator)
          raise DirectoryApiException.new e.message
        end
      else
        begin
          authority_uuid = DirectoryApi.create_contact(organization.authority_organization_administrator)
          organization.authority_organization_administrator.update_attributes({uuid: authority_uuid})
          DirectoryApi.create_organization(organization, organization.primary_organization_administrator, organization.secondary_organization_administrator, organization.authority_organization_administrator, admin_account)
        rescue DirectoryApiException => e
          DirectoryApi.delete_contact(organization.primary_organization_administrator)
          DirectoryApi.delete_contact(organization.secondary_organization_administrator)
          if organization.authority_organization_administrator
            DirectoryApi.delete_contact(organization.authority_organization_administrator)
          end
          raise DirectoryApiException.new e.message
        end
      end

  end
end
