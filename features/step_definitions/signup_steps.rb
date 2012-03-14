Given /^I am on the signup page$/ do
  visit registration_path
end

Given /^I complete the agreement page$/ do
  check('#agreement')
  check('#media')
  check('#community')
end

Given /^I follow (\w+)$/ do |label|
  click_link(label)
end
