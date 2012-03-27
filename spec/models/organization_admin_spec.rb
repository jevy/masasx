require 'spec_helper'

describe OrganizationAdmin do

  it { should respond_to(:email) }

  it { should respond_to(:contact_info) }

  it { should respond_to(:organization) }

end
