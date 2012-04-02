Given /^I am logged\-in as a MasasxClerk$/ do
  masasx_clerk = Factory(:masasx_clerk, password: 'mypassword')

  visit new_masasx_clerk_session_path
  fill_in 'Email',    with: masasx_clerk.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Sign in'
end

Given /^an organization pending approval exists$/ do
  Factory(:organization_pending_approval)
end

When /^I am on the MasasxClerk admin dashboard page$/ do
  visit admin_dashboard_path
end
