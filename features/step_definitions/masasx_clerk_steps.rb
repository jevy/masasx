Given /^I am logged\-in as a MasasxClerk$/ do
  masasx_clerk = Factory(:masasx_clerk, password: 'mypassword')

  visit login_path
  fill_in 'Email',    with: masasx_clerk.email
  fill_in 'Password', with: 'mypassword'
  click_on 'Login'
end
