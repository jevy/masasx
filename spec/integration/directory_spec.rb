require 'spec_helper'

describe Directory do

  describe 'create_organization with different authority' do
    before do
      primary = FactoryGirl.create(:organization_admin,
                         first_name: 'Jevin',
                         last_name: 'Maltais111',
                         title: 'President',
                         language: 'en',
                         email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary')
      secondary = FactoryGirl.create(:organization_admin,
                         first_name: 'My 123',
                         last_name: 'Backup111',
                         title: 'President',
                         language: 'en',
                         email: 'someoneelse@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Secondary')
      authority = FactoryGirl.create(:organization_admin,
                         first_name: 'Someone 1234',
                         last_name: 'Important111',
                         title: 'President',
                         language: 'en',
                         email: 'important@quickjack.ca',
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
                         email: 'jevin@quickjack.ca',
                         office_phone: '613-265-5389',
                         organization: @organization,
                         role: 'Primary',
                         executive: false)
      secondary = FactoryGirl.create(:organization_admin,
                         first_name: 'My',
                         last_name: 'Backup222',
                         title: 'President',
                         language: 'en',
                         email: 'someoneelse@quickjack.ca',
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

  describe 'failed to create organization' do
    before do
      @organization = double(Organization, has_primary_executive?: false, has_secondary_executive?: false)
      @primary = double(OrganizationAdmin, update_attributes: true)
      @secondary = double(OrganizationAdmin, update_attributes: true)
      @authority = double(OrganizationAdmin, update_attributes: true)
      @organization.stub(:primary_organization_administrator).and_return(@primary)
      @organization.stub(:secondary_organization_administrator).and_return(@secondary)
      @organization.stub(:authority_organization_administrator).and_return(@authority)
      DirectoryApi.stub(:delete_contact)
    end

    describe 'because the primary contact failed' do
      before do
        DirectoryApi.stub(:create_contact).with(@primary).and_raise(DirectoryApiException)
      end

      it 'returns a DirectoryApiException' do
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end

      it 'should not create a secondary contact' do
        DirectoryApi.should_not_receive(:create_contact).with(@secondary)
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end

      it 'should not create an authority contact' do
        DirectoryApi.should_not_receive(:create_contact).with(@authority)
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end
    end

    describe 'because the secondary contact failed' do
      before do
        DirectoryApi.stub(:create_contact).with(@primary).and_return('a UUID')
        DirectoryApi.stub(:create_contact).with(@secondary).and_raise(DirectoryApiException)
      end

      it 'returns a DirectoryApiException' do
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end

      it 'removes the primary contact' do
        DirectoryApi.should_receive(:delete_contact).with(@primary)
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end

      it 'should not create an authority contact' do
        DirectoryApi.should_not_receive(:create_contact).with(@authority)
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end
    end

    describe 'because the authority contact failed' do
      before do
        DirectoryApi.stub(:create_contact).with(@primary).and_return('a UUID')
        DirectoryApi.stub(:create_contact).with(@secondary).and_return('a UUID')
        DirectoryApi.stub(:create_contact).with(@authority).and_raise(DirectoryApiException)
      end

      it 'returns a DirectoryApiException' do
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end

      it 'removes the primary and secondary contacts' do
        DirectoryApi.should_receive(:delete_contact).with(@primary)
        DirectoryApi.should_receive(:delete_contact).with(@secondary)
        expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
      end
    end

    describe 'because the organization creation failed' do
      context 'with authority admin' do
        before do
          DirectoryApi.stub(:create_contact).with(@primary).and_return('a UUID')
          DirectoryApi.stub(:create_contact).with(@secondary).and_return('a UUID')
          DirectoryApi.stub(:create_contact).with(@authority).and_return('a UUID')
          DirectoryApi.stub(:create_organization).and_raise(DirectoryApiException)
        end

        it 'returns a DirectoryApiException' do
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'removes the primary, secondary and authority contact' do
          DirectoryApi.should_receive(:delete_contact).with(@primary)
          DirectoryApi.should_receive(:delete_contact).with(@secondary)
          DirectoryApi.should_receive(:delete_contact).with(@authority)
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end
      end

      context 'with primary admin as executive' do
        before do
          @organization.stub(has_primary_executive?: true)
          DirectoryApi.stub(:create_contact).with(@primary).and_return('a UUID')
          DirectoryApi.stub(:create_contact).with(@secondary).and_return('a UUID')
          DirectoryApi.stub(:create_organization).and_raise(DirectoryApiException)
        end

        it 'returns a DirectoryApiException' do
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'removes the primary, secondary contacts' do
          DirectoryApi.should_receive(:delete_contact).with(@primary)
          DirectoryApi.should_receive(:delete_contact).with(@secondary)
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'does not try to remove an authority contact' do
          DirectoryApi.should_not_receive(:delete_contact).with(@authority)
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end
      end

      context 'with secondary admin as executive' do
        before do
          DirectoryApi.stub(:create_contact).with(@primary).and_return('a UUID')
          DirectoryApi.stub(:create_contact).with(@secondary).and_return('a UUID')
          DirectoryApi.stub(:create_organization).and_raise(DirectoryApiException)
          @organization.stub(has_secondary_executive?: true)
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'returns a DirectoryApiException' do
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'removes the primary, secondary contacts' do
          DirectoryApi.should_receive(:delete_contact).with(@primary)
          DirectoryApi.should_receive(:delete_contact).with(@secondary)
          expect {Directory.add_organization(@organization)}.to raise_error(DirectoryApiException)
        end

        it 'does not try to remove an authority contact' do
          DirectoryApi.should_not_receive(:delete_contact).with(@authority)
        end
      end
    end

  end
end
