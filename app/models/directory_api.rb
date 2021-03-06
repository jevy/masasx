class DirectoryApi
  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |faraday|
      faraday.request :retry, exceptions: [Faraday::Error::ClientError]
      #faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
    end
  end

  def self.create_organization(organization, organization_contact, primary, secondary)
    body = {
      "ou" => organization.uuid,
      "MasasUUID" => organization.uuid,
      "displayName" => organization.name,
      "MasasFullOrganizationName" => organization.name,
      "MasasContactURLs" => ["#{organization_contact.uuid} ORG", "#{primary.uuid} PRIMARY", "#{secondary.uuid} SECONDARY"],
      "MasasXAdminNote" => "REFERENCES: " + organization.references + "\n" + "NOTES: " + organization.admin_notes
    }.to_json

    connection.put("/organizations/#{organization.uuid}") do |request|
      request.headers["X-OpenIDM-Password"] = PASSWORD
      request.headers["X-OpenIDM-Username"] = USERNAME
      request.headers["If-None-Match"] = "*"
      request.headers["Content-Type"] = "application/json"
      request.body = body
      request.options.timeout = 3
    end

    true
  end

  def self.create_contact(contact)
    body = {
      "firstName" => contact.first_name,
      "lastName" => contact.last_name,
      "email" => contact.email,
      "office-phone" => contact.office_phone,
      "country" => contact.country,
      "address" => contact.address_as_single_line,
      "city" => contact.city,
      "prov" => contact.state,
      "postalCode" => contact.postal_code,
      "_id" => contact.uuid,
      "MasasUUID" => contact.uuid,
      "displayName" => contact.display_name,
      "department" => contact.organization.department
    }.to_json

    connection.put("/contacts/#{contact.uuid}") do |request|
      request.headers["X-OpenIDM-Password"] = PASSWORD
      request.headers["X-OpenIDM-Username"] = USERNAME
      request.headers["If-None-Match"] = "*"
      request.headers["Content-Type"] = "application/json"
      request.body = body
      request.options.timeout = 3
    end

    true
  end

  def self.create_organization_contact(contact)
    body = {
      "department" => contact.department,
      "lastName" => contact.name,
      "office-phone" => contact.office_phone,
      "country" => contact.country,
      "address" => contact.address_as_single_line,
      "city" => contact.city,
      "prov" => contact.state,
      "postalCode" => contact.postal_code,
      "_id" => contact.uuid,
      "MasasUUID" => contact.uuid,
      "displayName" => contact.name,
      "email" => contact.email,
      "website" => contact.website,
      "department" => contact.department
    }.to_json

    connection.put("/contacts/#{contact.uuid}") do |request|
      request.headers["X-OpenIDM-Password"] = PASSWORD
      request.headers["X-OpenIDM-Username"] = USERNAME
      request.headers["If-None-Match"] = "*"
      request.headers["Content-Type"] = "application/json"
      request.body = body
      request.options.timeout = 3
    end

    true
  end

  def self.delete_contact(contact)
    connection.delete("/contacts/#{contact.uuid}") do |request|
      request.headers["X-OpenIDM-Password"] = PASSWORD
      request.headers["X-OpenIDM-Username"] = USERNAME
    end

    true
  end
end
