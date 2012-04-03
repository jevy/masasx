require 'spec_helper'

describe Organization do

  it { should respond_to(:status) }

  it { should respond_to(:agreements) }

  it { should respond_to(:name) }

  it { should respond_to(:department) }

  it { should respond_to(:division) }

  it { should respond_to(:sub_division) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:telephone) }

  it { should respond_to(:website) }

  it { should respond_to(:primary_organization_administrator) }

  it { should respond_to(:secondary_organization_administrator) }

  it { should respond_to(:references_language) }

  it { should respond_to(:references) }

  it { should respond_to(:questions) }

  it { should respond_to(:accounts) }

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
      @organization = Organization.new
    end

    it 'is invalid without accepting the agreements' do
      @organization.agreements = [ 1, 2 ] # Just one accepted
      @organization.should be_invalid
    end

  end

  context '#complete_agreement!' do

    it "changes the status to 'organization' " do
      @organization = Organization.new

      @organization.complete_agreement!

      @organization.status.should eql('organization')
    end

  end

  context '#complete_organization!' do

    it "changes the status to 'primary_contact' " do
      @organization = Organization.new

      @organization.status = 'organization'

      @organization.complete_organization!

      @organization.status.should eql('primary_contact')
    end

  end

  context '#complete_primary_contact!' do

    it "changes the status to 'secondary_contact' " do
      @organization = Organization.new

      @organization.status = 'primary_contact'

      @organization.complete_primary_contact!

      @organization.status.should eql('secondary_contact')
    end

  end

  context '#complete_secondary_contact!' do

    it "changes the status to 'references' " do
      @organization = Organization.new

      @organization.status = 'secondary_contact'

      @organization.complete_secondary_contact!

      @organization.status.should eql('references')
    end

  end

  context '#complete_references!' do

    it "changes the status to 'completed' " do
      @organization = Organization.new

      @organization.status = 'references'

      @organization.complete_references!

      @organization.status.should eql('completed')
    end

  end

  context '#approve!' do

    it "changes to status to 'approved'" do
      @organization = Organization.new

      @organization.status = 'completed'

      @organization.approve!

      @organization.status.should eql('approved')
    end

  end

  context '#next!' do

    before do
      @organization = Organization.new
    end

    it 'transits from agreement to organization' do
      @organization.status = 'agreement'

      @organization.should_receive(:complete_agreement!)

      @organization.next!
    end

    it 'transits from organization to primary_contact' do
      @organization.status = 'organization'

      @organization.should_receive(:complete_organization!)

      @organization.next!
    end

    it 'transits from primary_contact to secondary_contact' do
      @organization.status = 'primary_contact'

      @organization.should_receive(:complete_primary_contact!)

      @organization.next!
    end

    it 'transits from secondary_contact to references' do
      @organization.status = 'secondary_contact'

      @organization.should_receive(:complete_secondary_contact!)

      @organization.next!
    end

    it 'transits from references to completed' do
      @organization.status = 'references'

      @organization.should_receive(:complete_references!)

      @organization.next!
    end

  end

  context 'administrators' do

    before do
      @organization = Factory.build(:organization)
      @organization.primary_organization_administrator_attributes   = Factory.attributes_for(:organization_admin, email: 'primary@example.com', contact_info: Factory.build(:contact, name: 'Luca Pette', office_email: 'luca@pette.com'))
      @organization.secondary_organization_administrator_attributes = Factory.attributes_for(:organization_admin, email: 'secondary@example.com')
    end

    it 'are created when organization is created' do
      @organization.save
      OrganizationAdmin.count.should eql 2
    end

    it 'have the correct contact info' do
      @organization.save
      OrganizationAdmin.first.contact_info.name.should eql 'Luca Pette'
      OrganizationAdmin.first.contact_info.office_email.should eql 'luca@pette.com'
    end

  end

  context '.pending_approval' do

    before do
      @organizations = FactoryGirl.create_list(:organization_pending_approval, 2)
    end

    it 'returns the organization pending approval' do
      Organization.pending_approval.should =~ @organizations
    end

  end

end
