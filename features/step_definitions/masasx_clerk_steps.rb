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

When /^I update the Organizations "([^"]*)" to "([^"]*)"$/ do |attribute, new_value|
  visit edit_admin_organization_path(Organization.last)
  fill_in attribute, with: new_value
  click_on "Update"
end

Then /^in the history, I should see that fire was updated$/ do
  within(:xpath, "//div[contains(@id,'history')]") do
    page.should have_content "Fire"
  end
end

When /^I am on the Organizations admin page for "([^"]*)"$/ do |organization_name|
  visit admin_organization_path(Organization.find_by_name(organization_name))
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
end

Then /^I should see the changes to the organization$/ do
  page.should have_content('Some Other Organization')
end

Then /^I should be on the specific Organizations admin page$/ do
  current_path.should match(/\/admin\/organizations\/\d/)
end

When /^I make changes to the contact$/ do
  fill_in "First name", with: 'Booga Booga First Name'
  fill_in "Title", with: 'Janitor'
  fill_in 'Email', with: 'something@ziggy.com'
end

Then /^I should see the changes to the Primary contact$/ do
  page.should have_content('Booga Booga First Name')
  page.should have_content('Janitor')
  page.should have_content('something@ziggy.com')
end

When /^I fill in the notes with "([^"]*)"$/ do |arg1|
  fill_in "Admin notes", with: arg1
end

Then /^within notes I should see "([^"]*)"$/ do |arg1|
  find_field('Admin notes').value.should eq arg1
end

Given /^an approved organization exists with a name of "([^"]*)"$/ do |org_name|
  @organization = FactoryGirl.create(:organization_approved, name: org_name)
end

Given /^an organization that is pending approval exists with a name of "([^"]*)"$/ do |org_name|
  @organization = FactoryGirl.create(:organization_pending_approval, name: org_name)
end


Then /^I should not be able to see modification buttons$/ do
  page.should_not have_link('Edit')
  page.should_not have_link('Approve')
  page.should_not have_link('Reject')
end

Then /^I should be able to edit the organization$/ do
  page.should have_link('Edit')
  page.should have_link('Approve')
  page.should have_link('Reject')
end
