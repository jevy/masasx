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
        'displayName' => organization.name,
        'PrimaryContactURI' => primary.uuid,
        'SecondaryContactURI' => secondary.uuid
      }
    response = connection.put("/organizations/") do |request|
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
      'title' => contact.title,
      'language' => contact.language,
      'email' => contact.email,
      'office-phone' => contact.office_phone,
      'MasasUUID' => contact.uuid
    }

    response = connection.put("/contacts/#{contact.office_phone}") do |request|
      request.body = body
    end

    if response.success?
      return parse_uuid(response.body)
    else
      raise DirectoryApiContactCreationException, "Message from OpenDJ: #{response.body}"
    end

  end

  def self.parse_uuid(returned_body)
      result = ActiveSupport::JSON.decode(returned_body)['MasasUUID']
      raise RuntimeError, "No UUID returned" if !result
      result
  end

  def self.delete_contact(contact)
    return false if !contact.uuid
    connection.delete("/masas/contacts/#{contact.uuid}")
    true
  end

end
