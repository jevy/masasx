Feature: MasasxClerk should be able to manage the entire system

  Background:
    Given I am logged-in as a MasasxClerk

  Scenario: MasasxClerk should see the number of pending Organization applications
    Given an organization pending approval exists with a name of "Organization Name"
    When I am on the Organizations admin page
    Then I should see "Pending (1)"

  Scenario: MasasxClerk should see the number of approved Organization applications
    Given an organization approved exists with a name of "Organization Name"
    When I am on the Organizations admin page
    Then I should see "Approved (1)"

  Scenario: MasasxClerk should see the number of rejected Organization applications
    Given an organization rejected exists with a name of "Organization Name"
    When I am on the Organizations admin page
    Then I should see "Rejected (1)"

  Scenario: MasasxClerk should be able to review all the pending Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    When I am on the Organizations admin page
    And I press "Pending"
    Then I should see "Organization Name"

  Scenario: MasasxClerk should be able to review all the approved Organization's application
    Given an organization approved exists with a name of "Organization Name"
    When I am on the Organizations admin page
    And I press "Approved"
    Then I should see "Organization Name"

  Scenario: MasasxClerk should be able to review all the rejected Organization's application
    Given an organization rejected exists with a name of "Organization Name"
    When I am on the Organizations admin page
    And I press "Rejected"
    Then I should see "Organization Name"

  Scenario: MasasxClerk should be able to approve an Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    And I press "View"
    When I press "Approve"
    Then I should be on the Organizations admin page
    And I should see "Approved (1)"

  Scenario: MasasxClerk should be able to reject an Organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    And I press "View"
    When I press "Reject"
    Then I should be on the Organizations admin page
    And I should see "Rejected (1)"

  Scenario Outline: MasasxClerk should be able to view the applicant's submitted application details
    Given an organization pending approval exists with a <field> of "<value>"
    And I am on the Organizations admin page
    And I press "Pending"
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
    And the following secondary contact for the organization "Organization Name" exists:
      | field          | value              |
      | name           | Ops Manager        |
      | email          | some@example.com   |
      | title          | Mister             |
      | mobile_email   | mobile@example.com |
      | office_phone   | 555-42-42-42       |
      | mobile_phone   | 555-24-24-24       |
      | executive      | true               |
      | address_line_1 | Nowhere, 42        |
      | city           | A city             |
      | country        | A country          |
      | state          | A state            |
      | postal_code    | 424242             |
    And I am on the Organizations admin page
    And I press "Pending"
    When I press "View"
    Then I should see "Ops Manager"
    And I should see "some@example.com"
    And I should see "Mister"
    And I should see "mobile@example.com"
    And I should see "555-42-42-42"
    And I should see "555-24-24-24"
    And I should see "Yes"
    And I should see "Nowhere, 42"
    And I should see "A city"
    And I should see "A country"
    And I should see "A state"
    And I should see "424242"

  Scenario: MasasxClerk should be able to view the applicant's submitted secondary contact details
    Given an organization pending approval exists with a name of "Organization Name"
    And the following secondary contact for the organization "Organization Name" exists:
      | field          | value                       |
      | name           | Ops Secondary Manager       |
      | email          | somesecondary@example.com   |
      | title          | Secondary                   |
      | mobile_email   | mobilesecondary@example.com |
      | office_phone   | 555-42-42-42                |
      | mobile_phone   | 555-24-24-24                |
      | address_line_1 | Nowhere, 42                 |
      | city           | secondary city              |
      | country        | secondary country           |
      | state          | secondary state             |
      | postal_code    | 424242                      |
    And I am on the Organizations admin page
    And I press "Pending"
    When I press "View"
    Then I should see "Ops Secondary Manager"
    And I should see "somesecondary@example.com"
    And I should see "Secondary"
    And I should see "mobilesecondary@example.com"
    And I should see "555-42-42-42"
    And I should see "555-24-24-24"
    And I should see "Nowhere, 42"
    And I should see "secondary city"
    And I should see "secondary country"
    And I should see "secondary state"
    And I should see "424242"

  Scenario: After I login, I should be taken to the organizations admin page
    Then I should be on the Organizations admin page

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
    When I am on the Organizations admin page
    Then I should see "Pending (1)"
