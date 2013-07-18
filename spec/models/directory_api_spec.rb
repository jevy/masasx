require 'spec_helper'

describe DirectoryApi do

    before(:each) do
      WebMock.disable_net_connect!
      stub_request(:any, "https://ois.cloop.co/masas/contacts")
      stub_request(:any, "https://ois.cloop.co/masas/organizations")
    end

  describe 'create_organization' do
    before do
      @organization = FactoryGirl.create(:organization_pending_approval,
                                         name: 'Awesome organization',
                                         address_line_1: 'Nowhere 42',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6')
    end

    it 'sends the JSON data to the Directory' do
      json_hash =
      {
        "OrgName" => "Awesome organization",
        "address-line1" => "Nowhere 42",
        "province-state" => "Ontario",
        "country" => "CA",
        "postal-code" => "K1J 1A6"
      }
      # POST '/organizations' with json
      DirectoryApi.create_organization(@organization).should be_true
      a_request(:post, "https://ois.cloop.co/masas/organizations").with(body: json_hash.to_json).should have_been_made
    end
  end

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
                         name: 'Jevin Maltais',
                         title: 'President',
                         language: 'en',
                         office_email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      json_hash =
      {
        "firstName" => "Jevin Maltais",
        "lastName" => "",
        "title" => "President",
        "language" => "en",
        "email" => "jevin@quickjack.ca",
        "office-phone" => "613-265-5389"
      }
      DirectoryApi.create_contact(admin).should be_true
      a_request(:post, "https://ois.cloop.co/masas/contacts").with(body: json_hash.to_json).should have_been_made
    end
  end
end
