Given /^an approved organization "([^"]*)" exists$/ do |name|
  Factory(:organization, name: name)
end

Given /^I am logged-in as an Organization Administrator for "([^"]*)"$/ do |organization_name|
  organization_admin = Factory(:organization_admin, organization: Organization.find_by_name(organization_name), password: 'mypassword')

  visit login_path
  fill_in 'Email',    with: organization_admin.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Login'
end

Given /^I am on the organization adminstration page$/ do
  visit admin_root_path
end

When /^I fill in the user account information with the name "([^"]*)"$/ do |name|
  fill_in 'Name', with: name
  fill_in 'Access code', with: '42-42-42-42'
end

Then /^I should see the user account with name "([^"]*)"$/ do |name|
  page.should have_content(name)
end

Then /^"([^"]*)" should have all the permissions denied$/ do |name|
  page.should_not have_content('Yes')
end
