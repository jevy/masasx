class DirectoryApi
  def self.connection
    Faraday.new(url: URL, ssl: {verify: false}) do |faraday|
      faraday.request :retry, exceptions: [Faraday::Error::ClientError]
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
    end
  end
=begin
Issues with Organization:
1. There is no ORG contact (An Organization has three sets of contact data - ORG, PRIMARY, and SECONDARY).
2. Where is the address info going (i.e. the address, website, etc.) if there 
isn't an ORG contact along the lines of the primary.uuid and secondary.uuid that is refered to below?


Here is an example of an accurate ORG as it is in the LDAP directory (this is LDIF format, but it's reasonably
easy to read with the exception of the MasasXAdminNote, which is encoded. This particular example is for
the City of Banff and it was migrated from the old system. Address information in this example is shown in the 
MasasSummaryInfo block for later use and is not required right now from the APS.

dn: ou=ba5db6a1-bb6d-11e3-829d-b0428716c762,ou=organizations,dc=iam,dc=continuumloop,dc=com
MasasContactURLs: ba380630-bb6d-11e3-9c03-b0428716c762 PRIMARY
MasasContactURLs: ba474870-bb6d-11e3-8872-b0428716c762 SECONDARY
MasasContactURLs: ba5244f0-bb6d-11e3-9998-b0428716c762 ORG
MasasFullOrganizationName: Town of Banff
MasasSummaryInfo: Town of Banff, NONE, 403-762-1112, 110 Bear Street, Banff, Alberta, T1L 1A1
MasasUUID: ba5db6a1-bb6d-11e3-829d-b0428716c762
MasasXAdminNote:: VHlwZTogSVQKCkp1cmlzZGljdGlvbjogTG9jYWwKClJFRkVSRU5DRTogCgoKTk9URVM6IAoK
displayName: Town of Banff
ou: ba5db6a1-bb6d-11e3-829d-b0428716c762



=end
  def self.create_organization(organization, primary, secondary)
    body = {
      "ou" => organization.uuid,
      "MasasOrganizationScopes" => ["Federal"],
      "MasasOrganizationKinds" => "NGO",
      "MasasUUID" => organization.uuid,
      "displayName" => organization.name,
      "MasasOrganizationRole" => ["Police"],
      "MasasContactURLs" => ["#{primary.uuid} PRIMARY", "#{secondary.uuid} SECONDARY"],
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
=begin

Here is an EXAMPLE (LDIF) of a contact as well (The PRIMARY contact from the above example). The 
attribute names differ a bit in the LDIF from the JSON though as we named them in 
plain English (sn=LastName for example).

dn: uid=ba380630-bb6d-11e3-9c03-b0428716c762,ou=contacts,dc=iam,dc=continuumloop,dc=com
MasasAdminNote:   GIS Coordinator
MasasDepartment: Corporate Services
MasasUUID: ba380630-bb6d-11e3-9c03-b0428716c762
cn: Steve Nelson
mail: steve.nelson@banff.ca
sn: Steve Nelson
telephoneNumber: 403-762-1112
uid: ba380630-bb6d-11e3-9c03-b0428716c762

=end
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
