require 'spec_helper'

describe OrganizationAdmin do

  it { should respond_to(:organization) }

  it { should respond_to(:title) }

  it { should respond_to(:language) }

  it { should respond_to(:office_email) }

  it { should respond_to(:mobile_email) }

  it { should respond_to(:office_phone) }

  it { should respond_to(:mobile_phone) }

  it { should respond_to(:executive) }

  it { should respond_to(:address_line_1) }

  it { should respond_to(:address_line_2) }

  it { should respond_to(:city) }

  it { should respond_to(:state) }

  it { should respond_to(:country) }

  it { should respond_to(:postal_code) }

  describe 'email validation' do
    it 'passes with jevin@quickjack.ca' do
      OrganizationAdmin.new(email: 'jevin@quickjack.ca').should have(0).errors_on(:email)
    end

    it 'fails with bob' do
      OrganizationAdmin.new(email: 'bob').should have(1).errors_on(:email)
    end

  end

end
