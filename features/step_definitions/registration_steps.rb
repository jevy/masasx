Given /^I am on the signup page$/ do
  visit registration_path
end

Given /^I complete the agreement page$/ do
  check('I accept the Participation Agreement.')
  check('I am not a member of the media.')
  check('I certify that I am a bona fide member of the Canadian Emergency Management community and have a valid reason to join the MASAS-X community.')
end

Given /^I do not complete the agreement page$/ do
  check('I accept the Participation Agreement.')
  check('I am not a member of the media.')
end

Given /^I complete the organization page$/ do
  fill_in 'Organization Name',  with: 'Awesome Organization'
  fill_in 'Department',         with: 'Awesome Deparment'
  fill_in 'Address Line 1',     with: 'Nowhere, 42'
  fill_in 'Address Line 2',     with: 'NoBuilding Center - 42 floor'
  fill_in 'City',               with: 'Nocity'
  select 'Canada',              from: 'Country'
  select 'Ontario',             from: 'State/Prov'
  fill_in 'Telephone',          with: '555-42-42-42'
  fill_in 'Postal code',        with: '424242'
  fill_in 'Email',              with: 'blah@blah.com'
  fill_in 'Website',            with: 'http://www.example.com'
end

Given /^I complete the (\w+) Contact page$/ do |contact|
  fill_in 'First Name',           with: "John"
  fill_in 'Last Name',           with: "#{contact} Doe"
  select 'English',         from: 'Language'
  fill_in 'E-mail',  with: "john.doe.#{contact}@example.com"
  fill_in 'Office Phone',   with: '555-111-111-111'
  fill_in 'Address Line 1',     with: "#{contact} Nowhere, 42"
  fill_in 'Address Line 2',     with: "#{contact} NoBuilding Center - 42 floor"
  fill_in 'City',               with: "#{contact} Nocity"
  select 'Canada',              from: 'Country'
  select 'Ontario',             from: 'State/Prov'
  fill_in 'Postal code',        with: "#{contact} 424242"
end

Given /^I complete the References page$/ do
  fill_in 'References',          with: 'A nice guy told me'
  fill_in 'Comments/Questions',  with: 'What is the meaning of 42?'
end

Then /^I should be on the agreement page$/ do
  within('head title') do
    page.should have_content('Agreement')
  end
end

Then /^I should be on the organization page$/ do
  within('head title') do
    page.should have_content('Organization')
  end
end

Then /^I should be on the primary contact page$/ do
  within('head title') do
    page.should have_content('Primary Contact Information')
  end
end

Then /^I should be on the secondary contact page$/ do
  within('head title') do
    page.should have_content('Secondary Contact Information')
  end
end

Then /^I should be on the References page$/ do
  within('head title') do
    page.should have_content('References Information')
  end
end

Then /^I should see the (\w*) contact page completed$/ do |contact|
  page.find_field('First Name').value.should eql("John")
  page.find_field('Last Name').value.should eql("#{contact} Doe")
  page.find_field('Language').value.should eql('English')
  page.find_field('E-mail').value.should  eql("john.doe.#{contact}@example.com")
  page.find_field('Office Phone').value.should   eql('555-111-111-111')
end

Then /^I should see the organization page completed$/ do
  page.find_field('Organization Name').value.should  eql('Awesome Organization')
  page.find_field('Department').value.should         eql('Awesome Deparment')
  page.find_field('Address Line 1').value.should     eql('Nowhere, 42')
  page.find_field('Telephone').value.should          eql('555-42-42-42')
  page.find_field('Website').value.should            eql('http://www.example.com')
end

Then /^I should see the agreement page completed$/ do
  page.should have_checked_field('I accept the Participation Agreement.')
  page.should have_checked_field('I am not a member of the media.')
  page.should have_checked_field('I certify that I am a bona fide member of the Canadian Emergency Management community and have a valid reason to join the MASAS-X community.')
end

Then /^I should not be able to choose "([^"]*)"$/ do |label|
  page.find_field(label)[:disabled].should be_true
end

Then /^"([^"]*)" should be checked$/ do |label|
  page.should have_checked_field(label)
end

Given /^a MASAS-X Clerk exists$/ do
  @organization = FactoryGirl.create(:masasx_clerk)
end

Then /^a "([^"]*)" email should be sent$/ do |subject|
  mail = ActionMailer::Base.deliveries.last
  mail.subject.should == subject
end
