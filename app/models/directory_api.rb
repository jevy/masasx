require 'logger'
# we need a 3rd-party extension for some extra middleware:
require 'faraday_middleware'

class DirectoryApi
  URL = "https://ois.cloop.co"

  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |c|
      c.request :json
      c.adapter Faraday.default_adapter
    end
  end

  def self.create_organization(organization)
    body =
      {
        'OrgName' => organization.name,
        'address-line1' => organization.address_line_1,
        'province-state' => 'Ontario',
        'country' => organization.country,
        'postal-code' => organization.postal_code
      }
    response = connection.post("/masas/organizations") do |request|
      request.body = body
    end
    response.success? ? true : false
  end

  def self.create_contact(contact)
    body = {
      'firstName' => contact.name,
      'lastName' => '',
      'title' => contact.title,
      'language' => contact.language,
      'email' => contact.office_email,
      'office-phone' => contact.office_phone
    }
    response = connection.post("/masas/contacts") do |request|
      request.body = body
    end
    response.success? ? true : false
  end

end
