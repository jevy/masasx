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
      # We can't use retry middleware here, because Faraday 0.8.9
      # doesn't allow retrying requests failed after custom exceptions
      # i.e. Faraday::Error::ClientError. This seems to be fixed in
      # 0.9.0, but faraday_middleware is incompatible with it yet, so
      # we have to deal with retries on our own.
      # c.request :retry
      c.request :json
      c.response :logger
      c.adapter Faraday.default_adapter
      c.use Faraday::Response::RaiseError
    end
  end

  def self.create_organization(organization, primary, secondary)
    # Missing more stuff
    body = {
      'MasasOrganizationScopes' => ["Federal"],
      'MasasOrganizationKinds' => "NGO",
      'MasasUUID' => organization.uuid,
      'displayName' => organization.name,
      'MasasOrganizationRole' => ["Police"],
      'MasasContactURLs' => ["#{primary.masas_name} PRIMARY", "#{secondary.masas_name} SECONDARY"]
    }
    connection.put("/organizations/#{organization.masas_name}") do |request|
      request.headers['X-OpenIDM-Password'] = 'abcd1234'
      request.headers['X-OpenIDM-Username'] = 'gg_admin'
      request.headers['If-None-Match'] = '*'
      request.body = body
      request.options[:timeout] = 15
    end

    true
  rescue Faraday::Error::ClientError => exception
    retries ||= 2
    if retries > 0
      retries -= 1
      retry
    end
    raise DirectoryApiContactCreationException, "Message from OpenDJ: #{exception.response.try(:[], :body)}"
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

    connection.put("/contacts/#{contact.masas_name}") do |request|
      request.headers['X-OpenIDM-Password'] = 'abcd1234'
      request.headers['X-OpenIDM-Username'] = 'gg_admin'
      request.headers['If-None-Match'] = '*'
      request.body = body
      request.options[:timeout] = 15
    end

    true
  rescue Faraday::Error::ClientError => exception
    retries ||= 2
    if retries > 0
      retries -= 1
      retry
    end
    raise DirectoryApiContactCreationException, "Message from OpenDJ: #{exception.response.try(:[], :body)}"
  end

  def self.delete_contact(contact)
    response = connection.delete("/contacts/#{contact.masas_name}")
    response.success?
  rescue Faraday::Error::ClientError
    false
  end
end
