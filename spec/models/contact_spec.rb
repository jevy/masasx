require 'spec_helper'

describe Contact do

  it { should respond_to(:name) }

  it { should respond_to(:title) }

  it { should respond_to(:language) }

  it { should respond_to(:office_email) }

  it { should respond_to(:mobile_email) }

  it { should respond_to(:office_phone) }

  it { should respond_to(:mobile_phone) }

end
