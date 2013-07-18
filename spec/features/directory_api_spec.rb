require 'spec_helper'

feature 'Directory API' do

  before do
    masasx_clerk = FactoryGirl.create(:masasx_clerk, password: 'mypassword')

    visit '/masasx_clerks/sign_in'
    fill_in 'Email',    with: masasx_clerk.email
    fill_in 'Password', with: 'mypassword'
    click_on 'Sign in'
  end

  context 'approving an Organization', :vcr do

    before do
      @organization = FactoryGirl.create(:organization_pending_approval)
      FactoryGirl.create(:organization_admin, organization: @organization)
      FactoryGirl.create(:organization_admin, organization: @organization)

    end


    it 'should call the directory API' do
      Directory.stub(:add_organization).and_return(true)  # API approves the organization

      visit '/admin/organizations'
      click_on 'View'
      click_on 'Approve'
      page.should have_content('Organization successfully approved!')
    end

    it "displays an error if the call to the OpenDJ didn't work"
  end
end
