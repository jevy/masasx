class MasasxClerkMailer < ActionMailer::Base
  def new_organization(masasx_clerk, organization)
    @masasx_clerk = masasx_clerk
    @organization = organization
    mail(to: masasx_clerk.email, subject: "New organization")
  end
end
