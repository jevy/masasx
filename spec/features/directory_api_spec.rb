require 'spec_helper'

feature 'Directory API' do

  before do
    masasx_clerk = FactoryGirl.create(:masasx_clerk, password: 'mypassword')

    visit '/masasx_clerks/sign_in'
    fill_in 'Email',    with: masasx_clerk.email
    fill_in 'Password', with: 'mypassword'
    click_on 'Sign in'
  end

  context 'approving an Organization' do

    before do
      @organization = FactoryGirl.create(:organization_pending_approval)
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Primary')
      FactoryGirl.create(:organization_admin, organization: @organization, role: 'Secondary', executive: true)
    end

    it 'should call the directory API' do
      Directory.stub(:add_organization).and_return(true)  # API approves the organization

      visit '/admin/organizations'
      click_on 'View'
      click_on 'Approve'
      page.should have_content('Organization successfully approved!')
    end

    it 'displays an error if contact call to the OpenDJ contacts API didn\'t work' do
      stub_request(:any, /iam.continuumloop.com:9080\/.*/).to_return(status: 400, body: "Some contact error")

      visit '/admin/organizations'
      click_on 'View'
      click_on 'Approve'
      page.should have_content('Message from OpenDJ: Some contact error')
    end

  end
end
