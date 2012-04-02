Feature: MasasxClerk should be able to manage the entire system

  Background:
    Given I am logged-in as a MasasxClerk

    @wip
  Scenario: MasasxClerk should see the number of pending Organization applications
    Given an organization pending approval exists
    When I am on the MasasxClerk admin dashboard page
    Then I should see "1 Organizations pending approval"

  Scenario: MasasxClerk should be able to review all the Organization's application
    Given there is one Organization pending approval
    Given I am on MasasxClerk dashboard page
    Given I click "Review pending applications"
    Then I should see the organization's information
    Then I press "approve"

  Scenario: MasasxClerk should be able to review all the Organization's application
    Given there is one Organization pending approval
    Given I am on MasasxClerk dashboard page
    Given I click "Review pending applications"
    Then I should see the organization's information
    Then I press "reject"
