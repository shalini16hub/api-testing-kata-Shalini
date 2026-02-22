@e2e @booking
Feature: End to End hotel room booking through booking page

  This feature validates complete booking flow from the UI booking page
  using valid and invalid input combinations.

  Background:
    Given I open the hotel booking page


    @positive @sanity
  Scenario Outline: Successfully create a booking from booking page
    When I enter firstname "<firstname>"
    And I enter lastname "<lastname>"
    And I enter email "<email>"
    And I enter phone "<phone>"
    And I select checkin date "<checkin>"
    And I select checkout date "<checkout>"
    And I enter booking notes "<notes>"
    And I submit the booking form
    Then the booking should be created successfully
    And the booking confirmation should be displayed

    Examples:
      | firstname | lastname | email              | phone      | checkin     | checkout    | notes              |
      | John      | Smith    | john@test.com      | 9876543210 | 2026-03-10  | 2026-03-12  | Near lift please   |
      | Anita     | Kumar    | anita@test.com     | 9123456789 | 2026-03-15  | 2026-03-18  | High floor room    |


      @negative
  Scenario Outline: Booking fails when mandatory fields are missing
    When I enter firstname "<firstname>"
    And I enter lastname "<lastname>"
    And I enter email "<email>"
    And I enter phone "<phone>"
    And I select checkin date "<checkin>"
    And I select checkout date "<checkout>"
    And I submit the booking form
    Then the booking should not be created
    And a validation message should be displayed

    Examples:
      | firstname | lastname | email          | phone      | checkin     | checkout    |
      |           | Smith    | john@test.com  | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      |          | john@test.com  | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      | Smith    |                | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      | Smith    | john@test.com  |            | 2026-03-10  | 2026-03-12  |


      @negative
  Scenario Outline: Booking fails when email or phone format is invalid
    When I enter firstname "<firstname>"
    And I enter lastname "<lastname>"
    And I enter email "<email>"
    And I enter phone "<phone>"
    And I select checkin date "<checkin>"
    And I select checkout date "<checkout>"
    And I submit the booking form
    Then the booking should not be created
    And an input validation message should be displayed

    Examples:
      | firstname | lastname | email        | phone   | checkin     | checkout    |
      | John      | Smith    | wrongemail   | 98765   | 2026-03-10  | 2026-03-12  |



      @positive @roomtype
  Scenario Outline: Successfully create booking for different room types
    When I select room type "<roomType>"
    And I enter first name "<firstname>"
    And I enter last name "<lastname>"
    And I enter email "<email>"
    And I enter phone number "<phone>"
    And I select check-in date "<checkin>"
    And I select check-out date "<checkout>"
    And I submit the booking form
    Then the booking should be created successfully
    And the selected room type should be "<roomType>"

    Examples:
      | roomType | firstname | lastname | email         | phone      | checkin    | checkout   |
      | Single   | John      | Smith    | john@test.com | 9876543210 | 2026-03-10 | 2026-03-12 |
      | Double   | Anita     | Kumar    | anita@test.com| 9123456789 | 2026-03-15 | 2026-03-17 |
      | Suite    | Rahul     | Verma    | rahul@test.com| 9988776655 | 2026-03-20 | 2026-03-23 |


      @positive @roomtype
  Scenario Outline: Verify selected room type is displayed in booking confirmation
    When I select room type "<roomType>"
    And I complete the booking with valid customer and date details
    Then the booking should be created successfully
    And the booking confirmation should display room type "<roomType>"

    Examples:
      | roomType |
      | Single   |
      | Double   |
      | Suite    |