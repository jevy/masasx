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

  context 'before creating' do

    before do
      @user = User.new
    end

    it 'is in the agreement status' do
      @user.status.should eql('agreement')
    end

  end

  context 'creating' do

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

end
