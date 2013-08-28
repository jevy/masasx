require 'spec_helper'

describe DirectoryApi do

  describe 'create_contact' do
    before do
      @organization = FactoryGirl.create(:organization_pending_approval,
                                         name: 'Awesome organization',
                                         address_line_1: 'Nowhere 42',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6')
    end

    it 'sends the JSON data to the Directory for a primary admin' do
      admin = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais',
                         title: 'President',
                         language: 'en',
                         office_email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      VCR.use_cassette('primary_admin', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do
        # UUID regex
        DirectoryApi.create_contact(admin).should match /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
      end
    end
  end

  describe 'parse_uuid' do
    it "returns the uuid if it was a successful call" do
      returned_body = '{"MasasUUID": "b4be290c-f492-11e2-9504-0401041e8a01", "success": true}'
      DirectoryApi.parse_uuid(returned_body).should eq "b4be290c-f492-11e2-9504-0401041e8a01"
    end

    it "raise error if call wasn't a success" do
      returned_body = '{"success": false}'
      lambda {DirectoryApi.parse_uuid(returned_body)}.should raise_error
    end

  end
end
