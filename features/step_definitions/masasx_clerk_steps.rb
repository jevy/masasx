Given /^I am logged\-in as a MasasxClerk$/ do
  masasx_clerk = FactoryGirl.create(:masasx_clerk, password: 'mypassword')

  visit new_masasx_clerk_session_path
  fill_in 'Email',    with: masasx_clerk.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Sign in'
end

Given /^the following (\w+) contact for the organization "([^"]*)" exists:$/ do |role, organization_name, table|
  attributes                      = table.hashes.inject({}) { |hash, element| hash[element['field']] = element['value']; hash  }
  organization_admin              = OrganizationAdmin.new(attributes)
  organization_admin.role         = role.capitalize
  organization_admin.organization = Organization.where(name: organization_name).first
  organization_admin.save
end

When /^I am on the Organizations admin page$/ do
  visit admin_organizations_path
end

Then /^I should be on the Organizations admin page$/ do
  URI.parse(current_url).path.should eql(admin_organizations_path)
end
