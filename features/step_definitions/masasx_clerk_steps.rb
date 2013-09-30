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

Given /^I press the edit Primary contact button$/ do
  within(:xpath, "//table[2]/tbody/tr[1]") do
    click_on "Edit"
  end
end

When /^I make changes to the organization$/ do
  fill_in 'Organization Name', with: 'Some Other Organization'
  fill_in 'Division', with: 'Some other division'
end

Then /^I should see the changes to the organization$/ do
  page.should have_content('Some Other Organization')
  page.should have_content('Some other division')
end

Then /^I should be on the specific Organizations admin page$/ do
  current_path.should match(/\/admin\/organizations\/\d/)
end

When /^I make changes to the contact$/ do
  fill_in "First name", with: 'Booga Booga First Name'
  fill_in "Title", with: 'Janitor'
end

Then /^I should see the changes to the Primary contact$/ do
  page.should have_content('Booga Booga First Name')
  page.should have_content('Janitor')
end
