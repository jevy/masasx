require 'spec_helper'

describe User do

  it { should respond_to(:status) }

  it { should respond_to(:masax_agreement) }

  it { should respond_to(:media_agreement) }

  it { should respond_to(:community_agreement) }

  it { should respond_to(:organization_name) }

  it { should respond_to(:department) }

  it { should respond_to(:division) }

  it { should respond_to(:sub_division) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:telephone) }

  it { should respond_to(:website) }

  it { should respond_to(:primary_contact_name) }

  it { should respond_to(:primary_contact_title) }

  it { should respond_to(:primary_contact_language) }

  it { should respond_to(:primary_contact_office_email) }

  it { should respond_to(:primary_contact_mobile_email) }

  it { should respond_to(:primary_contact_office_phone) }

  it { should respond_to(:primary_contact_mobile_phone) }

  it { should respond_to(:secondary_contact_name) }

  it { should respond_to(:secondary_contact_title) }

  it { should respond_to(:secondary_contact_language) }

  it { should respond_to(:secondary_contact_office_email) }

  it { should respond_to(:secondary_contact_mobile_email) }

  it { should respond_to(:secondary_contact_office_phone) }

  it { should respond_to(:secondary_contact_mobile_phone) }

  it { should respond_to(:references_language) }

  it { should respond_to(:references) }

  it { should respond_to(:questions) }

  context 'before creating' do

    before do
      @user = User.new
    end

    it 'is in the agreement status' do
      @user.status.should eql('agreement')
    end

  end

  context 'agreement validations' do

    before do
      @user = User.new
    end

    it 'is invalid without accepting the masax agreement' do
      @user.masax_agreement = false

      @user.should be_invalid
    end

    it 'is invalid without accepting the media agreement' do
      @user.media_agreement = false

      @user.should be_invalid
    end

    it 'is invalid without accepting the community agreement' do
      @user.community_agreement = false

      @user.should be_invalid
    end

  end

  context '#complete_agreement!' do

    it "changes the status to 'organization' " do
      @user = User.new

      @user.complete_agreement!

      @user.status.should eql('organization')
    end

  end

  context '#complete_organization!' do

    it "changes the status to 'primary_contact' " do
      @user = User.new

      @user.status = 'organization'

      @user.complete_organization!

      @user.status.should eql('primary_contact')
    end

  end

  context '#complete_primary_contact!' do

    it "changes the status to 'secondary_contact' " do
      @user = User.new

      @user.status = 'primary_contact'

      @user.complete_primary_contact!

      @user.status.should eql('secondary_contact')
    end

  end

  context '#complete_secondary_contact!' do

    it "changes the status to 'references' " do
      @user = User.new

      @user.status = 'secondary_contact'

      @user.complete_secondary_contact!

      @user.status.should eql('references')
    end

  end

  context '#complete_references!' do

    it "changes the status to 'completed' " do
      @user = User.new

      @user.status = 'references'

      @user.complete_references!

      @user.status.should eql('completed')
    end

  end

  context '#next!' do

    before do
      @user = User.new
    end

    it 'transits from agreement to organization' do
      @user.status = 'agreement'

      @user.should_receive(:complete_agreement!)

      @user.next!
    end

    it 'transits from organization to primary_contact' do
      @user.status = 'organization'

      @user.should_receive(:complete_organization!)

      @user.next!
    end

    it 'transits from primary_contact to secondary_contact' do
      @user.status = 'primary_contact'

      @user.should_receive(:complete_primary_contact!)

      @user.next!
    end

    it 'transits from secondary_contact to references' do
      @user.status = 'secondary_contact'

      @user.should_receive(:complete_secondary_contact!)

      @user.next!
    end

    it 'transits from references to completed' do
      @user.status = 'references'

      @user.should_receive(:complete_references!)

      @user.next!
    end

  end

end
