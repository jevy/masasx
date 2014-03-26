require 'spec_helper'

describe Directory do

  describe 'failed to create organization' do
    before do
      @organization = double(Organization)
      @primary = double(OrganizationAdmin, update_attributes: true)
      @secondary = double(OrganizationAdmin, update_attributes: true)
      @organization.stub(:primary_organization_administrator).and_return(@primary)
      @organization.stub(:secondary_organization_administrator).and_return(@secondary)
      DirectoryApi.stub(:delete_contact)
    end

    describe 'because the primary contact failed' do
      before do
        DirectoryApi.stub(:create_contact).with(@primary).and_raise(Faraday::Error::ClientError.new(nil))
        @primary.stub(:uuid).and_return(nil)
        @secondary.stub(:uuid).and_return(nil)
      end

      it 'returns a Faraday::Error::ClientError' do
        expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
      end

      it 'should not create a secondary contact' do
        DirectoryApi.should_not_receive(:create_contact).with(@secondary)
        expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
      end
    end

    describe 'because the secondary contact failed' do
      before do
        DirectoryApi.stub(:create_contact).with(@primary).and_return(true)
        @primary.stub(:uuid).and_return('a UUID')
        @secondary.stub(:uuid).and_return(nil)
        DirectoryApi.stub(:create_contact).with(@secondary).and_raise(Faraday::Error::ClientError.new(nil))
      end

      it 'returns a Faraday::Error::ClientError' do
        expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
      end

      it 'removes the primary contact' do
        DirectoryApi.should_receive(:delete_contact).with(@primary)
        expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
      end
    end

    describe 'because the organization creation failed' do
      context 'with authority admin' do
        before do
          @primary.stub(:uuid).and_return('a UUID')
          @secondary.stub(:uuid).and_return('a UUID')
          DirectoryApi.stub(:create_contact).with(@primary).and_return(true)
          DirectoryApi.stub(:create_contact).with(@secondary).and_return(true)
          DirectoryApi.stub(:create_organization).and_raise(Faraday::Error::ClientError.new(nil))
        end

        it 'returns a Faraday::Error::ClientError' do
          expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
        end

        it 'removes the primary and secondary contact' do
          DirectoryApi.should_receive(:delete_contact).with(@primary)
          DirectoryApi.should_receive(:delete_contact).with(@secondary)
          expect { Directory.add_organization(@organization) }.to raise_error(Faraday::Error::ClientError)
        end
      end
    end
  end
end
