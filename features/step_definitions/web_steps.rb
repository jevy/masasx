When /^I follow "([^"]*)"$/ do |label|
  click_on(label)
end

When /^I press "([^"]*)"$/ do |label|
  click_on(label)
end

When /^I fill in the "([^"]*)" field with "([^"]*)"$/ do |field, content|
  fill_in field, with: content
end

Then /^I should see "([^"]*)"$/ do |message|
  page.should have_content(message)
end

Then /^I should not see "([^"]*)"$/ do |message|
  page.should_not have_content(message)
end

Given /^I leave the "([^"]*)" field blank$/ do |field|
  fill_in field, with: ""
end

Then /^show me the page$/ do
  save_and_open_page
end
