Given /^I am on the signup page$/ do
  visit registration_path
end

Given /^I complete the agreement page$/ do
  check('I accept the MASAS Information eXchange (MASAS-X) Pilot Participation Agreement.')
  check('I am not a member of the media.')
  check('I certify that I am a bona fide member of the Canadian Emergency Management community and have a valid reason to join the MASAS-X community.')
end

Given /^I do not complete the agreement page$/ do
  check('I accept the MASAS Information eXchange (MASAS-X) Pilot Participation Agreement.')
  check('I am not a member of the media.')
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

Given /^I complete the (\w+) Contact page$/ do |contact|
  fill_in 'Name',           with: "John #{contact} Doe"
  fill_in 'Title',          with: "Head of #{contact}"
  select 'English',         from: 'Language'
  fill_in 'Office e-mail',  with: "john.doe.#{contact}@example.com"
  fill_in 'Mobile e-mail',  with: "john.doe.#{contact}@mobile.com"
  fill_in 'Office Phone',   with: '555-111-111-111'
  fill_in 'Mobile Phone',   with: '555-222-222-222'
end

Given /^I complete the References page$/ do
  select 'English',              from: 'Language'
  fill_in 'References',          with: 'A nice guy told me'
  fill_in 'Comments/Questions',  with: 'What is the meaning of 42?'
end

Then /^I should see "([^"]*)"$/ do |message|
  page.should have_content(message)
end

Then /^I should be on the agreement page$/ do
  URI.parse(current_url).path.should eql(accept_agreement_path)
end
