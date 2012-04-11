Feature: A brand new organization may apply for an account

  Background:
    Given I am on the signup page

  Scenario: A brand new organization signs up for an account with the primary contact as the authority
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page as the authority
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the References page
    And I follow "Next"
    Then I should see "Thank you for applying to become a MASAS member."

  Scenario: A brand new organization signs up for an account with the secondary contact as the authority
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page as the authority
    And I follow "Next"
    And I complete the References page
    And I follow "Next"
    Then I should see "Thank you for applying to become a MASAS member."

  Scenario: A brand new organization signs up for an account with neither contact as the authority
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the Authority Contact page
    And I follow "Next"
    And I complete the References page
    And I follow "Next"
    Then I should see "Thank you for applying to become a MASAS member."

  Scenario: A brand new organization signs up for an account and tries to submit without an authority contact
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    Then I should see "You require an authority contact in your application."

  Scenario: A brand new organization signs up for an account with the primary contact as the authority, should not have the option to set the secondary as an authority contact
    Given I complete the agreement page
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page as the authority
    And I follow "Next"
    Then I should not be able to choose "Executive"

   Scenario: A brand new organization can navigate to the agreement page from the organization page
    Given I complete the agreement page
    And I follow "Next"
    When I follow "Previous"
    Then I should be on the agreement page
    And I should see the agreement page completed

  Scenario: A brand new organization can navigate to the organization page from the primary contact page
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    When I follow "Previous"
    Then I should be on the organization page
    And I should see the organization page completed

  Scenario: A brand new organization can navigate to the primary contact page from the secondary contact page
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the primary Contact page
    And I follow "Next"
    When I follow "Previous"
    Then I should be on the primary contact page
    And I should see the primary contact page completed

  Scenario: A brand new organization can navigate to the secondary contact page from the references page
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the primary Contact page
    And I follow "Next"
    And I complete the secondary Contact page
    And I follow "Next"
    When I follow "Previous"
    Then I should be on the secondary contact page
    And I should see the secondary contact page completed

  Scenario: A brand new organization does not complete the agreement page
    Given I do not complete the agreement page
    When I follow "Next"
    Then I should be on the agreement page
    And I should see "All the agreements must be accepted"

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
    And I complete the Primary Contact page as the authority
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the References page
    When I leave the "References" field blank
    And I follow "Next"
    Then I should see "References required"
