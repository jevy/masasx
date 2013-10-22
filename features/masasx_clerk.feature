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
    Given OpenDJ approves all organization requests
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

  Scenario: MasasxClerk should be able to edit the application's organization details
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    And I press "View"
    And I press "Edit"
    When I make changes to the organization
    And I press "Update"
    Then I should be on the specific Organizations admin page
    And I should see the changes to the organization

  Scenario: MasasxClerk should be able to edit the primary contact's info
    Given an organization with contacts exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    And I press "View"
    And I press the edit Primary contact button
    When I make changes to the contact
    And I press "Update"
    Then I should be on the specific Organizations admin page
    And I should see the changes to the Primary contact

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
      | first_name     | Ops                |
      | last_name      | Secondary Manager  |
      | email          | some@example.com   |
      | title          | Mister             |
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
    Then I should see "Secondary Manager"
    And I should see "some@example.com"
    And I should see "Mister"
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
      | first_name     | Ops                         |
      | last_name      | Secondary Manager           |
      | email          | somesecondary@example.com   |
      | title          | Secondary                   |
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
    And I should see "555-42-42-42"
    And I should see "555-24-24-24"
    And I should see "Nowhere, 42"
    And I should see "secondary city"
    And I should see "secondary country"
    And I should see "secondary state"
    And I should see "424242"

  Scenario: MasaxClerk can add notes to the organization's application
    Given an organization pending approval exists with a name of "Organization Name"
    And I am on the Organizations admin page
    And I press "Pending"
    And I press "View"
    When I fill in the notes with "This is some updated info"
    And I press "Update Notes"
    Then within notes I should see "This is some updated info"

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

  Scenario: Users no longer editable if application has been accepted
    Given an approved organization exists with a name of "Organization Name"
    When I am on the Organizations admin page
    And I press "Approved (1)"
    Then I should not see a "View" link

  Scenario: User can visit the contact edit button if application has been accepted
    Given an organization that is pending approval exists with a name of "Organization Name"
    When I am on the Organizations admin page
    Then I should see a "View" link

  Scenario: Masasx clerk can sign out
    When I press "Logout"
    Then I should see "Email"
    And I should see "Password"

