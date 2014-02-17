require 'logger'
# we need a 3rd-party extension for some extra middleware:
require 'faraday_middleware'

class DirectoryApiException < RuntimeError; end
class DirectoryApiContactCreationException < DirectoryApiException; end
class DirectoryApiOrganizationCreationException < DirectoryApiException; end

class DirectoryApi
  URL = "http://iam.continuumloop.com:9080"

  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |c|
      c.request :json
      #c.response :logger
      c.adapter Faraday.default_adapter
    end
  end

  def self.create_organization(organization, primary, secondary, executive, admin_account)
    # Missing more stuff
    body =
      {
          'MasasOrganizationScopes' => ["Federal"],
          'MasasOrganizationKinds' => "NGO",
          'MasasUUID' => organization.uuid,
          'displayName' => organization.name,
          'MasasOrganizationRole' => ["Police"],
          'MasasContactURLs' => ["#{primary.masas_name} PRIMARY", "#{secondary.masas_name} SECONDARY"]
      }
    response = connection.put("/organizations/#{organization.masas_name}") do |request|
      request.body = body
    end

    if response.success?
      return true
    else
      raise DirectoryApiOrganizationCreationException, "Message from OpenDJ: #{response.body}"
    end

  end

  def self.create_contact(contact)
    body = {
      'firstName' => contact.first_name,
      'lastName' => contact.last_name,
      'email' => contact.email,
      'office-phone' => contact.office_phone,
      '_id' => contact.masas_name,
      'MasasUUID' => contact.uuid,
      'displayName' => contact.display_name
    }

    response = connection.put("/contacts/#{contact.masas_name}") do |request|
      request.body = body
    end

    if response.success?
      return true
    else
      raise DirectoryApiContactCreationException, "Message from OpenDJ: #{response.body}"
    end

  end

  def self.delete_contact(contact)
    response = connection.delete("/contacts/#{contact.masas_name}")
    response.success?
  end

end
