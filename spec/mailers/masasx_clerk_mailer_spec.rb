require "spec_helper"

describe MasasxClerkMailer do
  let(:masasx_clerk) { FactoryGirl.create(:masasx_clerk) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:mail) { MasasxClerkMailer.new_organization(masasx_clerk, organization) }

  it "sets the subject" do
    mail.subject.should == "New organization"
  end

  it "sets the receiver email" do
    mail.to.should == [masasx_clerk.email]
  end

  it "sets the sender email" do
    mail.from.should == ["noreply@masasx.herokuapp.com"]
  end

  it "renders organization name" do
    mail.body.to_s.should match(organization.name)
  end
end
