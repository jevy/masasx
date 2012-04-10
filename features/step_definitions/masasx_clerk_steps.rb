Given /^I am logged\-in as a MasasxClerk$/ do
  masasx_clerk = FactoryGirl.create(:masasx_clerk, password: 'mypassword')

  visit new_masasx_clerk_session_path
  fill_in 'Email',    with: masasx_clerk.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Sign in'
end

Given /^the following (\w+) contact for the organization "([^"]*)" exists:$/ do |role, organization_name, table|
  organization_admin              = OrganizationAdmin.new(table.hashes.first)
  organization_admin.role         = role.capitalize
  organization_admin.organization = Organization.where(name: organization_name).first
  organization_admin.save
end

When /^I am on the MasasxClerk admin dashboard page$/ do
  visit admin_dashboard_path
end

Then /^I should be on the MasasxClerk admin dashboard page$/ do
  URI.parse(current_url).path.should eql(admin_dashboard_path)
end

Then /^I should be on the MasasxClerk review pending applications page$/ do
  #TODO test query string
  URI.parse(current_url).path.should eql(admin_organizations_path)
end
