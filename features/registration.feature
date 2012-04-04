Feature: A brand new organization may apply for an account

  Background:
    Given I am on the signup page

  Scenario: A brand new organization signs up for an account
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the References page
    And I follow "Next"
    Then I should see "Thank you for applying to become a MASAS member."

  Scenario: A brand new organization does not complete the agreement page
    Given I do not complete the agreement page
    When I follow "Next"
    Then I should be on the agreement page
    And I should see "You must accept all the agreements."

  Scenario: A new organization does not enter the organization name
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    When I leave the "Name" field blank
    And I follow "Next"
    Then I should see "Name required"

  Scenario: A new organization does not enter an email for the primary contact
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    When I leave the "Office e-mail" field blank
    And I follow "Next"
    Then I should see "Email address required"
    And I should not see "Password required"

  Scenario: A new organization does not enter an email or password for the secondary contact
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    When I leave the "Office e-mail" field blank
    And I follow "Next"
    Then I should see "Email address required"
    And I should not see "Password required"

  Scenario: A new organization does not enter any references for the references page
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the References page
    When I leave the "References" field blank
    And I follow "Next"
    Then I should see "References required"
