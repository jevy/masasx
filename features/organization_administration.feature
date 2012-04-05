Feature: An appoved organization can create and manage their own user accounts
  In order to allow the organizations to self manage their users
  As an Organization Administrator
  I can create, change Permissions and rename my Organization's User Accounts

  Background:
    Given an organization approved exists with a name of "Ottawa Fire Services"
    And I am logged-in as an Organization Administrator for "Ottawa Fire Services"

  Scenario: After I login, I should be taken to the admin dashboard
    Then I should be on the Organization admin dashboard page

  Scenario: I can create a User Account
    Given I am on the accounts organization administration page
    When I press "Add New User Account"
    And I fill in the user account information with the name "Ops Manager"
    And I press "Save"
    Then I should see "Ops Manager"
    And "Ops Manager" should have all the permissions denied

  Scenario: I can edit a User Account's details
    Given the following account exists:
      | Name        | Organization               |
      | Ops Manager | Name: Ottawa Fire Services |
    When I am on the accounts organization administration page
    And I follow "Ops Manager"
    And I fill in the "Name" field with "Night Ops Manager"
    And I press "Save"
    Then I should see "Night Ops Manager"

  Scenario: I can edit a User Account's permissions and it is persistant
    Given the following account exists:
      | Name        | Organization               |
      | Ops Manager | Name: Ottawa Fire Services |
    When I am on the accounts organization administration page
    And I press "Edit Permissions"
    And I select "Yes" for the "Cms Service" permission
    And I press "Exit Edit Permissions"
    Then I am on the accounts organization administration page
    And I should see "Ops Manager" have the "Yes" for "Cms Service"

  Scenario: I can manage only user accounts for my organization
    Given an organization approved exists with a name of "Ottawa Sky Watchers"
    And the following accounts exist:
      | Name                    | Organization               |
      | Ops Fire Manager        | Name: Ottawa Fire Services |
      | Ops Fire Senior Manager | Name: Ottawa Fire Services |
      | Ops Sky Manager         | Name: Ottawa Sky Watchers  |
    When I am on the accounts organization administration page
    Then I should see "Ops Fire Manager"
    And I should see "Ops Fire Senior Manager"
    And I should not see "Ops Sky Manager"

  Scenario: I can remove a user account
    Given the following accounts exist:
      | Name                    | Organization               |
      | Ops Fire Manager        | Name: Ottawa Fire Services |
      | Ops Fire Senior Manager | Name: Ottawa Fire Services |
      | Ops Fire Super Manager  | Name: Ottawa Fire Services |
    And I am on the accounts organization administration page
    When I press "Remove"
    Then I should see "2 User Accounts"
