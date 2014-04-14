require 'spec_helper'

describe AdminAccount do

  subject do
    AdminAccount.new(FactoryGirl.create(:organization_admin,
                       first_name: 'Jevin',
                       last_name: 'Maltais',
                       language: 'en',
                       email: 'jevin@quickjack.ca',
                       office_phone: '613-265-5389',
                       organization: @organization,
                       role: 'Primary'))
  end

  its(:username) { should eq('jmaltais') }
  its(:password) { should eq('somestaticpasswd') }
  its(:accesscode) { should eq('somestaticaccesscode') }
end
