Feature: Track changes to an application
  In order to allow for getting context of how an application has progressed
  As a MasasxClerk
  I can see the history of changes made by the administrator

  Background:
    Given I am logged-in as a MasasxClerk
    And an organization new exists with a name of "Organization Name"

  Scenario: If I make a change and update, I should see those changes
    When I update the Organizations "Department" to "Fire"
    And I am on the Organizations admin page for "Organization Name"
    Then in the history, I should see that fire was updated

