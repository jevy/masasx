require 'spec_helper'

describe OrganizationAdmin do

  it { should respond_to(:organization) }

  it { should respond_to(:title) }

  it { should respond_to(:language) }

  it { should respond_to(:email) }

  it { should respond_to(:office_phone) }

  it { should respond_to(:mobile_phone) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:address_line_2) }

  it { should respond_to(:city) }

  it { should respond_to(:state) }

  it { should respond_to(:country) }

  it { should respond_to(:postal_code) }

  it "should have a UUID" do
    FactoryGirl.create(:organization_admin).uuid.should match /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
  end

  it "should not update the UUID during an update" do
    org = FactoryGirl.create(:organization_admin)
    expect{
      org.first_name = 'New name'
      org.save
    }.to_not change{org.uuid}
  end

  describe 'email validation' do
    it 'passes with jevin@quickjack.ca' do
      OrganizationAdmin.new(email: 'jevin@quickjack.ca').should have(0).errors_on(:email)
    end

    it 'fails with bob' do
      OrganizationAdmin.new(email: 'bob').should have(1).errors_on(:email)
    end

  end

  describe 'masas_name' do
    it "Jevin Maltais" do
      admin = FactoryGirl.create(:organization_admin, first_name: 'Jevin', last_name: 'Maltais').masas_name.should eql "jevin_maltais"
    end

    it "Marcel Van Wilder" do
      admin = FactoryGirl.create(:organization_admin, first_name: 'Marcel', last_name: 'Van Wilder').masas_name.should eql "marcel_van_wilder"
    end
  end

  describe 'display_name' do
    it "Jevin Maltais" do
      admin = FactoryGirl.create(:organization_admin, first_name: 'Jevin', last_name: 'Maltais').display_name.should eql "Jevin Maltais"
    end

    it "Marcel Van Wilder" do
      admin = FactoryGirl.create(:organization_admin, first_name: 'Marcel', last_name: 'Van wilder').display_name.should eql "Marcel Van Wilder"
    end
  end

end
