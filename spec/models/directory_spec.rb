require 'spec_helper'

describe Directory do

  context 'add_organization' do

    before do
      @organization = FactoryGirl.create(:organization_pending_approval)
      primary_admin = FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary')
      secondary_admin = FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary')
    end

    it 'should call the correct order of DirectoryApi' do
      DirectoryApi.should_receive(:create_organization).with(@organization)
      DirectoryApi.should_receive(:create_contact).with(@organization.primary_organization_administrator)
      DirectoryApi.should_receive(:create_contact).with(@organization.secondary_organization_administrator)
      Directory.add_organization(@organization)
    end

  end

end
