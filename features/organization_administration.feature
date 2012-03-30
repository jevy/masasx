Feature: An appoved organization can create and manage their own user accounts
  In order to allow the organizations to self manage their users
  As an Organization Administrator
  I can create, change Permissions and rename my Organization's User Accounts

  Background:
    Given an approved organization "Ottawa Fire Services" exists
    And I am logged-in as an Organization Administrator for "Ottawa Fire Services"

  Scenario: I can create a User Account
    Given I am on the accounts organization administration page
    When I press "Add New User Account"
    And I fill in the user account information with the name "Ops Manager"
    And I press "Save"
    Then I should see the user account with name "Ops Manager"
    And "Ops Manager" should have all the permissions denied

  Scenario: I can edit a User Account's details
    Given a user account "Ops Manager" exists for organization "Ottawa Fire Services"
    When I am on the accounts organization administration page
    And I follow "Ops Manager"
    And I fill in the "Name" field with "Night Ops Manager"
    And I press "Save"
    Then I should see "Night Ops Manager"

  Scenario: I can edit a User Account's permissions and it is persistant
    Given a user account "Ops Manager" exists for organization "Ottawa Fire Services"
    When I am on the accounts organization administration page
    And I press "Edit Permissions"
    And I select "Yes" for the "Cms Service" permission
    And I press "Exit Edit Permissions"
    Then I am on the accounts organization administration page
    And I should see "Ops Manager" have the "Yes" for "Cms Service"
