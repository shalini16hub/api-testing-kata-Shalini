@booking @api @update
Feature: Update an existing booking


  Background:
    Given the booking service is available
    And today is within the current month
    And a customer has the ability to request changes to an existing booking


  @positive @regression @put
  Scenario Outline: Update all booking details successfully for an eligible booking
    Given a confirmed eligible booking already exists
    When the customer requests to fully update the booking with the following details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | <fname>   | <lname>  | <price>    | <deposit>   | <checkin>  | <checkout> |
    And the system validates the request and applies the approved changes to the existing booking
    And the system recalculates the booking amount when required
    And the system records the update activity for audit and tracking purposes
    Then the customer is able to view the updated booking details in the booking summary

    Examples:
      | fname | lname | price | deposit | checkin    | checkout   |
      | Alex  | Brown | 220   | true    | 2026-02-20 | 2026-02-23 |


  @positive @patch
  Scenario Outline: Update only the customer's first name for an eligible booking
    Given a confirmed eligible booking already exists
    When the customer requests to partially update the first name to "<firstname>"
    And the system validates the request and applies the approved change to the existing booking
    And the system records the update activity for audit and tracking purposes
    Then the customer is able to view the updated first name "<firstname>" in the booking details

    Examples:
      | firstname |
      | Michael   |


  @positive @patch
  Scenario Outline: Update only the customer's last name for an eligible booking
    Given a confirmed eligible booking already exists
    When the customer requests to partially update the last name to "<lastname>"
    And the system validates the request and applies the approved change to the existing booking
    And the system records the update activity for audit and tracking purposes
    Then the customer is able to view the updated last name "<lastname>" in the booking details

    Examples:
      | lastname |
      | Taylor   |


  @positive @put
  Scenario Outline: Update booking stay dates successfully for an eligible booking
    Given a confirmed eligible booking already exists
    And rooms are available for check-in "<checkin>" and check-out "<checkout>"
    When the customer requests to update the stay dates
    And the system validates the request, checks room availability and applies the approved changes to the existing booking
    And the system records the update activity for audit and tracking purposes
    Then the customer is able to view the updated stay dates in the booking summary

    Examples:
      | checkin    | checkout   |
      | 2026-02-25 | 2026-02-27 |


  @positive @put
  Scenario Outline: Update the total booking price for an eligible booking
    Given a confirmed eligible booking already exists
    When the customer requests to update the total price to <totalprice>
    And the system validates the request and applies the approved change to the existing booking
    And the system recalculates the booking amount based on the updated price
    And the system records the update activity for audit and tracking purposes
    Then the customer is able to view the revised total price <totalprice> in the booking summary

    Examples:
      | totalprice |
      | 300        |


  @negative @business
  Scenario Outline: Fail to update a non-existing booking
    When the customer attempts to update a booking with reference <booking_id>
    And the system verifies the booking reference before applying any change
    Then the customer is informed that the booking does not exist
    And no booking information is modified

    Examples:
      | booking_id |
      | 99999      |


  @negative @security @put @patch
  Scenario Outline: Fail to update a booking when the customer is not authenticated
    Given a booking exists with reference <booking_id>
    When the customer attempts to update the booking using a "<token_type>" authentication token
    And the system validates the customer identity before applying any change
    Then the customer is informed that authentication is required
    And the booking remains unchanged

    Examples:
      | booking_id | token_type |
      | 1          | invalid    |
      | 1          | empty      |


  @negative @validation @patch
  Scenario Outline: Fail to update the first name when the value is invalid
    Given a confirmed eligible booking already exists
    When the customer requests to update the first name to "<firstname>"
    And the system validates the request before applying the change
    Then the customer is informed about the validation issue "<expected_error>"
    And the booking remains unchanged

    Examples:
      | firstname                         | expected_error                |
      | Jo                                | size must be between 3 and 18 |
      | ThisIsAVeryLongFirstNameExceeding | size must be between 3 and 18 |


  @negative @validation @patch
  Scenario Outline: Fail to update the last name when the value is invalid
    Given a confirmed eligible booking already exists
    When the customer requests to update the last name to "<lastname>"
    And the system validates the request before applying the change
    Then the customer is informed about the validation issue "<expected_error>"
    And the booking remains unchanged

    Examples:
      | lastname                          | expected_error                |
      | Li                                | size must be between 3 and 30 |
      | ThisIsAnExtremelyLongLastNameHere | size must be between 3 and 30 |


  @negative @validation @put
  Scenario Outline: Fail to update the stay dates when the dates are invalid
    Given a confirmed eligible booking already exists
    When the customer requests to update the stay dates to check-in "<checkin>" and check-out "<checkout>"
    And the system validates the date range before applying the change
    Then the customer is informed about the validation issue "<expected_error>"
    And the booking remains unchanged

    Examples:
      | checkin    | checkout   | expected_error                  |
      | 2026-02-28 | 2026-02-26 | checkout must be after checkin |


  @negative @business @put
  Scenario Outline: Fail to update stay dates when rooms are not available
    Given a confirmed eligible booking already exists
    And no rooms are available for check-in "<checkin>" and check-out "<checkout>"
    When the customer requests to update the stay dates
    And the system validates the request and checks room availability before applying the change
    Then the customer is informed that the selected dates are not available
    And the existing booking remains unchanged

    Examples:
      | checkin    | checkout   |
      | 2026-02-18 | 2026-02-20 |


  @negative @business @put @patch
  Scenario Outline: Fail to update a booking that has already been cancelled
    Given a booking exists with reference <booking_id> and status "Cancelled"
    When the customer requests to update the booking details
    And the system validates the booking status before applying any change
    Then the customer is informed that cancelled bookings cannot be modified
    And the booking remains unchanged

    Examples:
      | booking_id |
      | 10         |


  @negative @business
  Scenario: Fail to update a booking that is not eligible for update
    Given a confirmed booking exists with a check-in date outside the allowed update period
    When the customer requests to update the booking details
    Then the system rejects the request
    And the customer is informed that the booking is not eligible for update
    And the booking remains unchanged