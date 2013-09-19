require 'logger'
# we need a 3rd-party extension for some extra middleware:
require 'faraday_middleware'

class DirectoryApiException < RuntimeError; end

class DirectoryApi
  URL = "https://ois.continuumloop.com"

  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |c|
      c.request :json
      #c.response :logger
      c.adapter Faraday.default_adapter
    end
  end

  def self.create_organization(organization, primary_uri, secondary_uri, authority_uri, admin_account)
    body =
      {
        'OrgName' => organization.name,
        'address-line1' => organization.address_line_1,
        'province-state' => 'Ontario',
        'country' => organization.country,
        'postal-code' => organization.postal_code,
        'PrimaryContactURI' => primary_uri,
        'SecondaryContactURI' => secondary_uri,
        'ExecutiveContactURI' => primary_uri,
        'PrimaryContactURI' => primary_uri,
        'AdminAccount' =>
           { 'UserName' => admin_account.username,
             'ContactURI' => primary_uri,
             'Password' => admin_account.password,
             'AccessCode' => admin_account.accesscode
           }
      }
    response = connection.post("/masas/organizations/") do |request|
      request.body = body
    end

    if response.success?
      return true
    elsif response.status == 409
      raise DirectoryApiException, "Organization or Admin Contact already exists"
    else
      raise RuntimeError, "Unknown issue posting organization to Directory"
    end

  end

  def self.create_contact(contact)
    body = {
      'firstName' => contact.first_name,
      'lastName' => contact.last_name,
      'title' => contact.title,
      'language' => contact.language,
      'email' => contact.email,
      'office-phone' => contact.office_phone
    }
    response = connection.post("/masas/contacts/") do |request|
      request.body = body
    end
    response.success? ? parse_uuid(response.body) : false
  end

  def self.parse_uuid(returned_body)
      result = ActiveSupport::JSON.decode(returned_body)['MasasUUID']
      raise RuntimeError, "No UUID returned" if !result
      result
  end

end
