require 'spec_helper'

describe Directory do

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
        @primary.stub(:uuid).and_return(nil)
        @secondary.stub(:uuid).and_return(nil)
        @authority.stub(:uuid).and_return(nil)
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
        @primary.stub(:uuid).and_return('a UUID')
        @secondary.stub(:uuid).and_return(nil)
        @authority.stub(:uuid).and_return(nil)
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
        @primary.stub(:uuid).and_return('a UUID')
        @secondary.stub(:uuid).and_return('a UUID')
        @authority.stub(:uuid).and_return(nil)
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
          @primary.stub(:uuid).and_return('a UUID')
          @secondary.stub(:uuid).and_return('a UUID')
          @authority.stub(:uuid).and_return('a UUID')
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
          @organization.stub(:authority_organization_administrator).and_return(nil)
          @primary.stub(:uuid).and_return('a UUID')
          @secondary.stub(:uuid).and_return('a UUID')
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
          @primary.stub(:uuid).and_return('a UUID')
          @secondary.stub(:uuid).and_return('a UUID')
          @organization.stub(:authority_organization_administrator).and_return(nil)
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
