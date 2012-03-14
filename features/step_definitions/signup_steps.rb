Given /^I am on the signup page$/ do
  visit registration_path
end

Given /^I complete the agreement page$/ do
  check('I accept the MASAS Information eXchange (MASAS-X) Pilot Participation Agreement.')
  check('I am not a member of the media.')
  check('I certify that I am a bona fide member of the Canadian Emergency Management community and have a valid reason to join the MASAS-X community.')
end

Given /^I follow "(\w+)"$/ do |label|
  click_button(label)
end

Given /^I complete the organization page$/ do
  fill_in 'Organization Name',  with: 'Awesome Organization'
  fill_in 'Department',         with: 'Awesome Deparment'
  fill_in 'Division',           with: 'Awesome Division'
  fill_in 'Sub Division',       with: 'Awesome Sub Division'
  fill_in 'Address Line 1',     with: 'Nowhere, 42'
  fill_in 'Telephone',          with: '555-42-42-42'
  fill_in 'Website',            with: 'http://www.example.com'
end
