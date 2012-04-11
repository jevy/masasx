module Navigator

  DEFAULT_NAVIGATION  = [:agreement, :organization, :primary_contact, :secondary_contact, :references]

  EXTENDED_NAVIGATION = [:agreement, :organization, :primary_contact, :secondary_contact, :authority, :references]

  def self.steps organization
    if organization.primary_organization_administrator.present? &&
      organization.secondary_organization_administrator.present? &&
      organization.secondary_organization_administrator.persisted? &&
      !organization.has_executive?
     EXTENDED_NAVIGATION
    else
      DEFAULT_NAVIGATION
    end
  end

end
