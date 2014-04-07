require 'spec_helper'

describe Directory do

  context 'add_organization' do

    before do
      @organization = FactoryGirl.create(:organization, status: 'new')
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary')
      DirectoryApi.stub!(:create_organization)
      DirectoryApi.stub!(:create_contact)
      DirectoryApi.stub!(:create_organization_contact)
      @admin = double(AdminAccount)
      AdminAccount.stub(:new).and_return(@admin)
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary')
    end

    it 'should create contacts for an primary, and secondary contacts' do
      DirectoryApi.should_receive(:create_contact).exactly(2).times
      Directory.add_organization(@organization)
    end

    it 'should create and organization contact for an organization' do
      DirectoryApi.should_receive(:create_organization_contact).exactly(1).times
      Directory.add_organization(@organization)
    end

    it 'calls DirectoryApi with two arguments' do
      DirectoryApi.should_receive(:create_organization).with(@organization,
                                                             @organization.as_contact,
                                                             @organization.primary_organization_administrator,
                                                             @organization.secondary_organization_administrator)
      Directory.add_organization(@organization)
    end

  end

end
