@javascript
Feature: A brand new organization may apply for an account

  Background:
    Given I am on the signup page

  Scenario: A brand new organization signs up for an account
    Given I complete the agreement page
    And a MASAS-X Clerk exists
    When I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    And I follow "Next"
    And I complete the References page
    And I follow "Next"
    Then I should see "Your application has been received and a confirmation email has been sent to the Primary Contact"
    And a "New organization" email should be sent

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

  Scenario Outline: A new organization does not enter the organization name
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    When I leave the "<field>" field blank
    And I follow "Next"
    Then I should see "<message>"

    Examples:
      | field          | message                 |
      | Name           | Name required           |
      | Address Line 1 | Address Line 1 required |
      | City           | City required           |
      | Postal code    | Postal code required    |

  Scenario Outline: A new organization does not enter required values for the primary contact
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    When I leave the "<field>" field blank
    And I follow "Next"
    Then I should see "<message>"

    Examples:
      | field         | message                |
      | E-mail        | Email address required |
      | Office Phone  | Phone required         |
      | Name          | Name required          |

  Scenario Outline: A new organization does not enter required values for the secondary contact
    Given I complete the agreement page
    And I follow "Next"
    And I complete the organization page
    And I follow "Next"
    And I complete the Primary Contact page
    And I follow "Next"
    And I complete the Secondary Contact page
    When I leave the "<field>" field blank
    And I follow "Next"
    Then I should see "<message>"

    Examples:
      | field         | message                |
      | E-mail        | Email address required |
      | Office Phone  | Phone required         |
      | Name          | Name required          |
