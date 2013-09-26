require 'spec_helper'

describe Directory do

  describe 'create_organization with different authority' do
    before do
      primary = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais111',
                         title: 'President',
                         language: 'en',
                         office_email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      secondary = FactoryGirl.create(:organization_admin,
                         first_name: 'My 123',
                         last_name: 'Backup111',
                         title: 'President',
                         language: 'en',
                         office_email: 'someoneelse@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Secondary')
      authority = FactoryGirl.create(:organization_admin,
                         first_name: 'Someone 1234',
                         last_name: 'Important111',
                         title: 'President',
                         language: 'en',
                         office_email: 'important@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Authority')
      @organization = FactoryGirl.create(:organization_pending_approval,
                                         name: 'Awesome organization 111',
                                         address_line_1: 'Nowhere 42',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6',
                                         authority_organization_administrator: authority,
                                         primary_organization_administrator: primary,
                                         secondary_organization_administrator: secondary)
    end

    it 'sends the JSON data to the Directory' do
      VCR.use_cassette('organization', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do
        Directory.add_organization(@organization).should be_true
      end
    end
  end

  describe 'create_organization with secondary as executive' do
    before do
      primary = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais222',
                         title: 'President',
                         language: 'en',
                         office_email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary',
                         executive: false)
      secondary = FactoryGirl.create(:organization_admin,
                         first_name: 'My',
                         last_name: 'Backup222',
                         title: 'President',
                         language: 'en',
                         office_email: 'someoneelse@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Secondary',
                         executive: true)
      @organization = FactoryGirl.create(:organization_pending_approval,
                                         name: 'Awesome organization 222',
                                         address_line_1: 'Nowhere 42',
                                         country: 'CA',
                                         postal_code: 'K1J 1A6',
                                         primary_organization_administrator: primary,
                                         secondary_organization_administrator: secondary)
    end

    it 'sends the JSON data to the Directory' do
      VCR.use_cassette('organization', :record => :new_episodes, :match_requests_on => [:method, :uri, :body]) do
        Directory.add_organization(@organization).should be_true
      end
    end
  end
end
