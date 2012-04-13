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
    And I press "View"
    When I press "Approve"
    Then I should be on the MasasxClerk admin dashboard page
    And I should see "1 Organizations approved"

  Scenario: MasasxClerk should be able to reject an Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    And I press "View"
    When I press "Reject"
    Then I should be on the MasasxClerk admin dashboard page
    And I should see "1 Organizations rejected"

  Scenario Outline: MasasxClerk should be able to view the applicant's submitted application details
    Given an organization pending approval exists with a <field> of "<value>"
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    When I press "View"
    Then I should see "<value>"

    Examples:
      | field          | value                  |
      | name           | Organization Name      |
      | department     | Awesome Department     |
      | division       | Great Division         |
      | sub division   | Great Sub-division     |
      | telephone      | 555-42-42-42           |
      | website        | http://www.example.com |
      | references     | Jevin told me          |
      | questions      | What's up?             |
      | address line 1 | Line 1                 |
      | address line 2 | Line 2                 |
      | city           | My city                |
      | country        | My Country             |
      | state          | My state               |
      | postal code    | 424242                 |

  Scenario: MasasxClerk should be able to view the applicant's submitted primary contact details
    Given an organization pending approval exists with a name of "Organization Name"
    And the following primary contact for the organization "Organization Name" exists:
      | name        | email               | title  | mobile_email       | office_phone | mobile_phone | executive |
      | Ops Manager | someguy@example.com | Mister | mobile@example.com | 555-42-42-42 | 555-24-24-24 | true      |
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    When I press "View"
    Then I should see "Ops Manager"
    And I should see "someguy@example.com"
    And I should see "Mister"
    And I should see "mobile@example.com"
    And I should see "555-42-42-42"
    And I should see "555-24-24-24"
    And I should see "Yes"

  Scenario: MasasxClerk should be able to view the applicant's submitted secondary contact details
    Given an organization pending approval exists with a name of "Organization Name"
    And the following secondary contact for the organization "Organization Name" exists:
      | name         | email                     | title         | mobile_email                | office_phone | mobile_phone |
      | Ops Operator | somesecondary@example.com | Mister Second | mobilesecondary@example.com | 555-43-43-43 | 555-23-23-23 |
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    When I press "View"
    Then I should see "Ops Operator"
    And I should see "somesecondary@example.com"
    And I should see "Mister Second"
    And I should see "mobilesecondary@example.com"
    And I should see "555-43-43-43"
    And I should see "555-23-23-23"

  Scenario: MasasxClerk should be able to return to the review pending applications page from application details page
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the MasasxClerk admin dashboard page
    And I press "Review Pending Applications"
    And I press "View"
    When I press "Back to review applications"
    Then I should be on the MasasxClerk review pending applications page

  Scenario: After I login, I should be taken to the admin dashboard
    Then I should be on the MasasxClerk admin dashboard page

  Scenario: End to end registration test
    Given I am on the signup page
    And I complete the agreement page
    And I follow "Next"
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
    When I am on the MasasxClerk admin dashboard page
    Then I should see "1 Organizations pending approval"
