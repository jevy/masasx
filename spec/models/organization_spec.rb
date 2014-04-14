require 'spec_helper'

describe Organization do

  it { should respond_to(:status) }

  it { should respond_to(:agreements) }

  it { should respond_to(:name) }

  it { should respond_to(:department) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:address_line_2) }

  it { should respond_to(:city) }

  it { should respond_to(:state) }

  it { should respond_to(:country) }

  it { should respond_to(:postal_code) }

  it { should respond_to(:telephone) }

  it { should respond_to(:website) }

  it { should respond_to(:as_contact) }

  it { should respond_to(:primary_organization_administrator) }

  it { should respond_to(:secondary_organization_administrator) }

  it { should respond_to(:references) }

  it { should respond_to(:questions) }

  it "should have a UUID" do
    FactoryGirl.create(:organization).uuid.should match /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
  end

  it "should not update the UUID during an update" do
    org = FactoryGirl.create(:organization)
    expect{
      org.name = 'New name'
      org.save
    }.to_not change{org.uuid}
  end

  context 'before creating' do

    before do
      @organization = Organization.new
    end

    it 'is in the agreement status' do
      @organization.status.should eql('agreement')
    end

  end

  context 'agreement validations' do

    before do
      @organization = FactoryGirl.create(:organization)
    end

    it 'is invalid without accepting the agreements' do
      @organization.agreements = [ 1, 2 ] # Just one accepted
      @organization.should be_invalid
    end

  end

  describe 'masas_name' do
    it "is derived from the name" do
      FactoryGirl.create(:organization, name: 'Awesome Organization').masas_name.should eql 'awesome_organization'
    end

  end

  describe 'url validation' do
    before do
      @org = Organization.new(status: 'organization')
    end

    it 'passes with http://www.quickjack.ca' do
      @org.website = 'http://www.quickjack.ca'
      @org.should have(0).errors_on(:website)
    end

    it 'passes with https://some.gov.gc.ca' do
      @org.website = 'http://some.gov.gc.ca'
      @org.should have(0).errors_on(:website)
    end

    it 'passes with http://www.quickjack.ca/subsite' do
      @org.website = 'http://www.quickjack.ca/subsite'
      @org.should have(0).errors_on(:website)
    end

    it 'fails with bob' do
      @org.website = 'bob'
      @org.should have(1).errors_on(:website)
    end

  end

  describe '#next!' do

    before do
      @organization = FactoryGirl.create(:organization)
    end

    context 'from agreement to organization' do

      it "changes the status to 'organization' " do
        @organization.next!

        @organization.status.should eql('organization')
      end

    end

    context 'from organization to primary_contact' do

      it "changes the status to 'primary_contact' " do
        @organization.status = 'organization'

        @organization.next!

        @organization.status.should eql('primary_contact')
      end

    end

    context 'from primary_contact to secondary_contact' do

      it "changes the status to 'secondary_contact' " do
        @organization.status = 'primary_contact'

        @organization.next!

        @organization.status.should eql('secondary_contact')
      end

    end

    context 'from secondary_contact' do

      it "changes the status to 'references'" do
        @organization.status = 'secondary_contact'

        @organization.next!

        @organization.status.should eql('references')
      end

    end

    context 'from references to new' do

      it "changes the status to 'new' " do
        @organization.status = 'references'

        @organization.next!

        @organization.status.should eql('new')
      end

    end

  end

  describe '#previous!' do

    before do
      @organization = FactoryGirl.create(:organization)
    end

    context 'from organization to agreement' do

      it "changes the status to 'agreement' " do
        @organization.status = 'organization'

        @organization.previous!

        @organization.status.should eql('agreement')
      end

    end

    context 'from primary_contact to organization' do

      it "changes the status to 'organization'" do
        @organization.status = 'primary_contact'

        @organization.previous!

        @organization.status.should eql('organization')
      end

    end

    context 'from secondary_contact to primary_contact' do

      it "changes the status to 'primary_contact'" do
        @organization.status = 'secondary_contact'

        @organization.previous!

        @organization.status.should eql('primary_contact')
      end

    end

    context 'from references' do

      it "changes the status to 'secondary_contact'" do
        @organization.status = 'references'

        @organization.previous!

        @organization.status.should eql('secondary_contact')
      end

    end

  end

  describe '#approve!' do

    it "changes to status from 'new' to 'approved'" do
      Directory.stub(:add_organization).and_return(:true)
      @organization = FactoryGirl.create(:organization_new)
      @organization.approve!
      @organization.status.should eql('approved')
    end

    it "changes to status from 'in_progress' to 'approved'" do
      Directory.stub(:add_organization).and_return(:true)
      @organization = FactoryGirl.create(:organization_in_progress)
      @organization.approve!
      @organization.status.should eql('approved')
    end

    it "changes to status from 'on_hold' to 'approved'" do
      Directory.stub(:add_organization).and_return(:true)
      @organization = FactoryGirl.create(:organization_on_hold)
      @organization.approve!
      @organization.status.should eql('approved')
    end

    it "submits the organization to the Directory" do
      @organization = FactoryGirl.create(:organization)

      Directory.should_receive(:add_organization).with(@organization).once

      @organization.status = 'new'

      @organization.approve!
    end

  end

  describe '#reject!' do

    it "changes to status to 'rejected'" do
      @organization = FactoryGirl.create(:organization)

      @organization.status = 'new'

      @organization.reject!

      @organization.status.should eql('rejected')
    end

  end

  describe '.pending_approval' do

    before do
      @organizations =
        FactoryGirl.create_list(:organization_new, 2) +
        FactoryGirl.create_list(:organization_in_progress, 2) +
        FactoryGirl.create_list(:organization_on_hold, 2)
    end

    it 'returns the organization pending approval' do
      Organization.pending_approval.should =~ @organizations
    end

  end

  describe '.approved' do

    before do
      @organizations = FactoryGirl.create_list(:organization_approved, 2)
    end

    it 'returns the approved organizations' do
      Organization.approved.should =~ @organizations
    end

  end

  describe '.rejected' do

    before do
      @organizations = FactoryGirl.create_list(:organization_rejected, 2)
    end

    it 'returns the rejected organizations' do
      Organization.rejected.should =~ @organizations
    end

  end

  describe '.can_update_attributes?' do

    it 'is true if in new state' do
      FactoryGirl.create(:organization_new).can_update_attributes?.should be_true
    end

    it 'is false if in approved state' do
      FactoryGirl.create(:organization_approved).can_update_attributes?.should be_false
    end

    it 'is true if in rejected state' do
      FactoryGirl.create(:organization_rejected).can_update_attributes?.should be_false
    end
  end

  describe '.as_contact' do
    it 'returns a struct that acts like an OrganizationAdmin' do
      org_contact = FactoryGirl.create(:organization).as_contact
      org_contact.should respond_to(:department)
      org_contact.should respond_to(:address_as_single_line)
      org_contact.should respond_to(:city)
      org_contact.should respond_to(:state)
      org_contact.should respond_to(:country)
      org_contact.should respond_to(:office_phone)
      org_contact.should respond_to(:website)
      org_contact.should respond_to(:uuid)
      org_contact.should respond_to(:name)
      org_contact.should respond_to(:postal_code)
    end

  end

end
