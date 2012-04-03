Feature: MasasxClerk should be able to manage the entire system

  Background:
    Given I am logged-in as a MasasxClerk

  Scenario: MasasxClerk should see the number of pending Organization applications
    Given an organization pending approval exists with a name of "Organization Name"
    When I am on the MasasxClerk admin dashboard page
    Then I should see "1 Organizations pending approval"

  Scenario: MasasxClerk should be able to review all the Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    When I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    Then I should see "Organization Name"

  Scenario: MasasxClerk should be able to approve an Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    When I press "Approve"
    Then I should be on the MasasxClerk admin dashboard page
    And I should see "1 Organizations approved"

  Scenario: MasasxClerk should be able to reject an Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    When I press "Reject"
    Then I should be on the MasasxClerk admin dashboard page
    And I should see "1 Organizations rejected"
