class DirectoryApi
  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |faraday|
      faraday.request :retry, exceptions: [Faraday::Error::ClientError]
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
    end
  end

  def self.create_organization(organization, primary, secondary)
    body = {
      "ou" => organization.masas_name,
      "MasasOrganizationScopes" => ["Federal"],
      "MasasOrganizationKinds" => "NGO",
      "MasasUUID" => organization.uuid,
      "displayName" => organization.name,
      "MasasOrganizationRole" => ["Police"],
      "MasasContactURLs" => ["#{primary.masas_name} PRIMARY", "#{secondary.masas_name} SECONDARY"],
    }.to_json

    connection.put("/organizations/#{organization.masas_name}") do |request|
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
      "_id" => contact.masas_name,
      "MasasUUID" => contact.uuid,
      "displayName" => contact.display_name
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
