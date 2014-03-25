Feature: The organization is read-only on approved or rejected

  Background:
    Given I am logged-in as a MasasxClerk

  Scenario: MasasxClerk should see fields disabled if organization is approved
    Given an organization approved exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Approved"
    When I press "View"
    Then I should not be able to see modification buttons

  Scenario: MasasxClerk should see fields disabled if organization is rejected
    Given an organization rejected exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Rejected"
    When I press "View"
    Then I should not be able to see modification buttons

  Scenario: MasasxClerk should see fields enabled if organization is new
    Given an organization new exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    When I press "View"
    Then I should be able to edit the organization
