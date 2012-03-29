When /^I press "([^"]*)"$/ do |label|
  click_on(label)
end

Then /^I should see "([^"]*)"$/ do |message|
  page.should have_content(message)
end
