Feature: An appoved organization can create and manage their own user accounts
    In order to allow the organizations to self manage their users
    As an Organization Administrator
    I can create, change Permissions and rename my Organization's User Accounts

    Background:
        Given there is an approved organization "Ottawa Fire Services"
        And I am an Organization Administrator for "Ottawa Fire Services"

    Scenario: I can create a User Account
        Given I am on the organization adminstration page
        And I press "Add New User Account"
        And I fill in the user account information for with role name "Ops Manager"
        And I press "Save"
        Then I should see the role "Ops Manager"
        And "Ops Manager" should have all the permissions denied

    Scenario: I can edit a User Account's details
        Given role "Ops Manager" exists
        And I am on the organization adminstration page
        And I click the "Ops Manager" link
        And I fill in the "Role" field with "Night Ops Manager"
        Then I press "Save"
        Then I should see "Nigh Ops Manager"

    Scenario: I can edit a User Account's permissions and is persistant
        Given role "Ops Manager" exists
        And I am on the organization adminstration page
        And I click "Edit permissions"
        And I select "No" for the "Account Admin" admin permission
        And I click "Exit edit permissions"
        And when I am on the organization adminstration page
        Then I should see "Ops Manager" have the "No" for "Account Admin"
