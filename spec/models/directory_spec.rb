require 'spec_helper'

describe Directory do

  context 'add_organization' do

    before do
      @organization = FactoryGirl.create(:organization, status: 'pending_approval')
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary')
      DirectoryApi.stub!(:create_organization)
      DirectoryApi.stub!(:create_contact)
      @admin = double(AdminAccount)
      AdminAccount.stub(:new).and_return(@admin)
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary')
    end

    it 'should create a third contact' do
      DirectoryApi.should_receive(:create_contact).exactly(2).times
      Directory.add_organization(@organization)
    end

    it 'calls DirectoryApi with two arguments' do
      DirectoryApi.should_receive(:create_organization).with(@organization,
                                                             @organization.primary_organization_administrator,
                                                             @organization.secondary_organization_administrator)
      Directory.add_organization(@organization)
    end

  end

end
