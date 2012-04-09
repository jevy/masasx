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
      @organization = FactoryGirl.create(:organization)
    end

    it 'is invalid without accepting the agreements' do
      @organization.agreements = [ 1, 2 ] # Just one accepted
      @organization.should be_invalid
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

    context 'from secondary_contact to references' do

      it "changes the status to 'references' " do
        @organization.status = 'secondary_contact'

        @organization.next!

        @organization.status.should eql('references')
      end

    end

    context 'from references to pending_approval' do

      it "changes the status to 'pending_approval' " do
        @organization.status = 'references'

        @organization.next!

        @organization.status.should eql('pending_approval')
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

    context 'from references to secondary_contact' do

      it "changes the status to 'secondary_contact'" do
        @organization.status = 'references'

        @organization.previous!

        @organization.status.should eql('secondary_contact')
      end

    end

  end

  describe '#approve!' do

    it "changes to status to 'approved'" do
      @organization = FactoryGirl.create(:organization)

      @organization.status = 'pending_approval'

      @organization.approve!

      @organization.status.should eql('approved')
    end

  end

  describe '#reject!' do

    it "changes to status to 'rejected'" do
      @organization = FactoryGirl.create(:organization)

      @organization.status = 'pending_approval'

      @organization.reject!

      @organization.status.should eql('rejected')
    end

  end

  describe '.pending_approval' do

    before do
      @organizations = FactoryGirl.create_list(:organization_pending_approval, 2)
    end

    it 'returns the organization pending approval' do
      Organization.pending_approval.should =~ @organizations
    end

  end

  describe '.pending_approval' do

    before do
      @organizations = FactoryGirl.create_list(:organization_approved, 2)
    end

    it 'returns the approved organizations' do
      Organization.approved.should =~ @organizations
    end

  end

  describe '.approved' do

    before do
      @organizations = FactoryGirl.create_list(:organization_pending_approval, 2)
    end

    it 'returns the organizations pending approval' do
      Organization.pending_approval.should =~ @organizations
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

end
