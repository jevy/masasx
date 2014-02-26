require 'spec_helper'

describe DirectoryApi do

  describe 'create_organization' do
    before do
      @organization = FactoryGirl.create(:organization, name: 'Awesome Organization')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary', first_name: 'Primary', last_name: 'Admin')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary', first_name: 'Secondary', last_name: 'Admin')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Authority', first_name: 'Authority', last_name: 'Admin')
        stub_request(:put, /iam.continuumloop.com:9080\/contacts\//).to_return(status: 200)
    end

    it 'sends the correct JSON data to the right place' do
      expected_json_content =
        {
          'MasasOrganizationScopes' => ["Federal"],
          'MasasOrganizationKinds' => "NGO",
          'MasasUUID' => @organization.uuid,
          'displayName' => 'Awesome Organization',
          'MasasOrganizationRole' => ["Police"],
          'MasasContactURLs' => ["primary_admin PRIMARY", "secondary_admin SECONDARY"]
        }
      stub_request(:put, "http://iam.continuumloop.com:9080/organizations/awesome_organization").with(:body => expected_json_content.to_json).to_return(status: 200)
      DirectoryApi.create_organization(@organization,
                                       @organization.primary_organization_administrator,
                                       @organization.secondary_organization_administrator,
                                       @organization.authority_organization_administrator
                                      ).should be_true
    end
  end

  describe 'create_contact' do
    before do
      @organization = FactoryGirl.create(:organization_with_contacts,
                                         status: 'pending_approval',
                                         name: 'Awesome organization',
                                         address_line_1: '42 Nowhere',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6')
    end

    it 'sends the correct JSON data to the right place for a primary admin' do
      admin = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais',
                         title: 'President',
                         language: 'en',
                         email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      # UUID regex
      expected_json_content =
        {
          'firstName' => "Jevin",
          'lastName' => 'Maltais',
          'email' => "jevin@quickjack.ca",
          'office-phone' => '613-265-5389',
          '_id' => "jevin_maltais",
          'MasasUUID' => admin.uuid,
          'displayName' => "Jevin Maltais",
        }
      stub_request(:put, "http://iam.continuumloop.com:9080/contacts/jevin_maltais").with(:body => expected_json_content.to_json).to_return(status: 200)
      DirectoryApi.create_contact(admin).should be_true
    end
  end

  describe 'delete_contact' do
    it 'sends a DELETE request to the server and returns true if it worked' do
      @contact = FactoryGirl.create(:organization_admin, first_name: 'Jevin', last_name: 'Maltais')
      stub_request(:delete, "http://iam.continuumloop.com:9080/contacts/jevin_maltais").to_return(status: 200)
      DirectoryApi.delete_contact(@contact).should be_true
    end

    it 'sends a DELETE request to the server and returns false if it failed' do
      @contact = FactoryGirl.create(:organization_admin, first_name: 'Jevin', last_name: 'Maltais')
      stub_request(:delete, "http://iam.continuumloop.com:9080/contacts/jevin_maltais").to_return(status: 404)
      DirectoryApi.delete_contact(@contact).should be_false
    end
  end
end
