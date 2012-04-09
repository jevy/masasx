Given /^I am logged-in as an Organization Administrator for "([^"]*)"$/ do |organization_name|
  organization_admin = FactoryGirl.create(:organization_admin, organization: Organization.find_by_name(organization_name), password: 'mypassword')

  visit new_organization_admin_session_path
  fill_in 'Email',    with: organization_admin.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Sign in'
end

Given /^I am on the accounts organization administration page$/ do
  visit admin_accounts_path
end

When /^I fill in the user account information with the name "([^"]*)"$/ do |name|
  fill_in 'Name', with: name
  fill_in 'Access code', with: '42-42-42-42'
end

When /^I select "([^"]*)" for the "([^"]*)" permission$/ do |value, permission|
  select(value)
end

Then /^I should be on the Organization admin dashboard page$/ do
  URI.parse(current_url).path.should eql(admin_accounts_path)
end

Then /^I should see "([^"]*)" have the "([^"]*)" for "([^"]*)"$/ do |account_name, value, permission|
  page.should have_content(value)
end

Then /^"([^"]*)" should have all the permissions denied$/ do |name|
  page.should_not have_content('Yes')
end
