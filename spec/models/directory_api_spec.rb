require 'spec_helper'

describe DirectoryApi do

  describe 'create_organization' do
    before do
      @organization = FactoryGirl.create(:organization,
                                         name: 'Awesome organization 333',
                                         address_line_1: 'Nowhere 42',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary', last_name: 'Theadmin333', uuid: 'someuuid')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary', last_name: 'Not as important333', uuid: 'someuuid')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Authority', last_name: 'Important person333', uuid: 'someuuid')
    end

    it 'sends the JSON data to the Directory' do
      DirectoryApi.create_organization(@organization,
                                       @organization.primary_organization_administrator,
                                       @organization.secondary_organization_administrator,
                                       @organization.authority_organization_administrator,
                                       AdminAccount.new(@organization.primary_organization_administrator)
                                      ).should be_true
    end

    it 'raises an error if a conflict exists' do
      stub_request(:post, "https://ois.continuumloop.com/masas/organizations/").to_return(status: 409)
      stub_request(:post, "https://ois.continuumloop.com/masas/contacts/").to_return(status: 200)
      expect { DirectoryApi.create_organization(@organization,
                                                @organization.primary_organization_administrator,
                                                @organization.secondary_organization_administrator,
                                                @organization.authority_organization_administrator,
                                                AdminAccount.new(@organization.primary_organization_administrator))
             }.should raise_error DirectoryApiOrganizationCreationException
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

    it 'sends the JSON data to the Directory for a primary admin' do
      admin = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais444',
                         title: 'President',
                         language: 'en',
                         email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      # UUID regex
      DirectoryApi.create_contact(admin).should match /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
    end

    it 'raises an error if a conflict exists' do
      stub_request(:post, "https://ois.continuumloop.com/masas/contacts/").to_return(status: 409)
      expect {
        DirectoryApi.create_contact(@organization.primary_organization_administrator)
      }.should raise_error DirectoryApiContactCreationException
    end
  end

  describe 'parse_uuid' do
    it "returns the uuid if it was a successful call" do
      returned_body = '{"MasasUUID": "b4be290c-f492-11e2-9504-0401041e8a01", "success": true}'
      DirectoryApi.parse_uuid(returned_body).should eq "b4be290c-f492-11e2-9504-0401041e8a01"
    end

    it "returns false if call wasn't a success" do
      returned_body = '{"success": false}'
      lambda {DirectoryApi.parse_uuid(returned_body)}.should raise_error
    end

  end

  describe 'delete_contact' do
    it 'sends a DELETE request to the server' do
      @contact = FactoryGirl.create(:organization_admin, uuid: 'someuuid')
      stub_request(:delete, "https://ois.continuumloop.com/masas/contacts/someuuid").to_return(status: 200)
    end

    it 'returns false if not uuid exists for the contact' do
      @contact = FactoryGirl.create(:organization_admin, uuid: nil)
     DirectoryApi.delete_contact(@contact).should be_false
    end
  end
end
