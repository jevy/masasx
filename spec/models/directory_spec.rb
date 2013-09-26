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
    end

    describe 'if secondary contact is executive' do
      before do
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary', executive: true)
      end

      it 'should not create a third (authority) contact' do
        DirectoryApi.should_receive(:create_contact).exactly(2).times
        Directory.add_organization(@organization)
      end

      it 'calls DirectoryApi with secondary as fourth attribute' do
        DirectoryApi.should_receive(:create_organization).with(
          @organization,
          @organization.primary_organization_administrator,
          @organization.secondary_organization_administrator,
          @organization.secondary_organization_administrator,
          @admin
        )
        Directory.add_organization(@organization)
      end
    end

    describe 'if authority contact exists' do
      before do
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary')
        FactoryGirl.create(:organization_admin, organization: @organization, role: 'Authority')
      end

      it 'should create a third contact' do
        DirectoryApi.should_receive(:create_contact).exactly(3).times
        Directory.add_organization(@organization)
      end

      it 'calls DirectoryApi with authority as fourth attribute' do
        DirectoryApi.should_receive(:create_organization).with(
          @organization,
          @organization.primary_organization_administrator,
          @organization.secondary_organization_administrator,
          @organization.authority_organization_administrator,
          @admin
        )
        Directory.add_organization(@organization)
      end
    end

  end

end
