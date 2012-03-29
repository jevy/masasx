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
