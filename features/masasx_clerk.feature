Feature: MasasXAdmin should be able to manage the entire system

    Background:
        As an MasasXAdmin

    Scenario: MasasXAdmin should see the number of pending Organization applications
        Given there is one Organization pending approval
        Given I am on MasasXAdmin dashboard page
        Then I should see "1 Organization pending approval"

    Scenario: MasasXAdmin should be able to review all the Organization's application
        Given there is one Organization pending approval
        Given I am on MasasXAdmin dashboard page
        Given I click "Review pending applications"
        Then I should see the organization's information
        Then I press "approve"

    Scenario: MasasXAdmin should be able to review all the Organization's application
        Given there is one Organization pending approval
        Given I am on MasasXAdmin dashboard page
        Given I click "Review pending applications"
        Then I should see the organization's information
        Then I press "reject"
