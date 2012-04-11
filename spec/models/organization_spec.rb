require 'spec_helper'

describe Organization do

  it { should respond_to(:status) }

  it { should respond_to(:agreements) }

  it { should respond_to(:name) }

  it { should respond_to(:department) }

  it { should respond_to(:division) }

  it { should respond_to(:sub_division) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:address_line_2) }

  it { should respond_to(:city) }

  it { should respond_to(:state) }

  it { should respond_to(:country) }

  it { should respond_to(:postal_code) }

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

    context 'from secondary_contact' do

      context 'when it has the primary contact as executive' do

        it "changes the status to 'references'" do
          @organization.primary_organization_administrator = FactoryGirl.create(:organization_admin_executive)

          @organization.status = 'secondary_contact'

          @organization.next!

          @organization.status.should eql('references')
        end

      end

      context 'when it has the secondary contact as executive' do

        it "changes the status to 'references'" do
          @organization.secondary_organization_administrator = FactoryGirl.create(:organization_admin_executive)

          @organization.status = 'secondary_contact'

          @organization.next!

          @organization.status.should eql('references')
        end

      end

      context 'when it doesnt have an executive' do

        it "changes the status to 'authority'" do
          @organization.status = 'secondary_contact'

          @organization.next!

          @organization.status.should eql('authority')
        end

      end

    end

    context 'from authority to references' do

      it 'changes the status to references' do
        @organization.status = 'authority'

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

    context 'from authority to secondary contact' do

      it 'changes the status to secondary_contact' do
        @organization.status = 'authority'

        @organization.previous!

        @organization.status.should eql('secondary_contact')
      end

    end

    context 'from references' do

      context 'when primary contact is executive' do

        it "changes the status to 'secondary_contact'" do
          @organization.primary_organization_administrator = FactoryGirl.create(:organization_admin_executive, role: 'Primary')
          @organization.status = 'references'

          @organization.previous!

          @organization.status.should eql('secondary_contact')
        end

      end

      context 'when secondary contact is executive' do

        it "changes the status to 'secondary_contact'" do
          @organization.secondary_organization_administrator = FactoryGirl.create(:organization_admin_executive, role: 'Secondary')
          @organization.status = 'references'

          @organization.previous!

          @organization.status.should eql('secondary_contact')
        end

      end

      context 'when none of the primary or secondary contacts is executive' do

        it "changes the status to 'secondary_contact'" do
          @organization.status = 'references'

          @organization.previous!

          @organization.status.should eql('authority')
        end

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

  describe '#has_executive?' do

    context 'when the primary contact administrator is an executive' do

      it 'returns true' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin_executive))
        @organization.should have_executive
      end

    end

    context 'when the secondary contact administrator is an executive' do

      it 'returns true' do
        @organization = FactoryGirl.create(:organization, secondary_organization_administrator: FactoryGirl.create(:organization_admin_executive))
        @organization.should have_executive
      end

    end

    context 'when the authority contact is present' do

      it 'returns true' do
        @organization = FactoryGirl.create(:organization, authority_organization_administrator: FactoryGirl.create(:organization_admin, role: 'Authority'))
        @organization.should have_executive
      end

    end

    context 'when no authority contact is present' do

      it 'returns false' do
        @organization = FactoryGirl.create(:organization)
        @organization.should_not have_executive
      end

    end

  end

  describe '#has_primary_executive?' do

    context 'when the primary contact is executive' do

      it 'returns true' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin_executive))

        @organization.should have_primary_executive
      end

    end

    context 'when the primary contact is not executive' do

      it 'returns false' do
        @organization = FactoryGirl.create(:organization, primary_organization_administrator: FactoryGirl.create(:organization_admin))

        @organization.should_not have_primary_executive
      end

    end

  end

  describe '#has_secondary_executive?' do

    context 'when the secondary contact is executive' do

      it 'returns true' do
        @organization = FactoryGirl.create(:organization, secondary_organization_administrator: FactoryGirl.create(:organization_admin_executive))

        @organization.should have_secondary_executive
      end

    end

    context 'when the secondary contact is not executive' do

      it 'returns false' do
        @organization = FactoryGirl.create(:organization, secondary_organization_administrator: FactoryGirl.create(:organization_admin))

        @organization.should_not have_secondary_executive
      end

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
