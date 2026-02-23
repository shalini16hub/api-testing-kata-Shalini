@booking @api @update
Feature: Update booking via API

  Background:
    Given the booking API is available


  @positive @regression
  Scenario Outline: Update all booking details successfully
    And I have created a booking
    When I update the created booking with the following details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | <fname>   | <lname>  | <price>    | <deposit>   | <checkin>  | <checkout> |
    Then the response status code should be 200
    And the response body should reflect the updated booking details

    Examples:
      | fname  | lname | price | deposit | checkin    | checkout   |
      | Alex   | Brown | 220   | true    | 2024-08-01 | 2024-08-05 |


  @positive
  Scenario Outline: Update only firstname
    And I have created a booking
    When I update the created booking with firstname "<firstname>"
    Then the response status code should be 200
    And the response should contain updated firstname "<firstname>"

    Examples:
      | firstname |
      | Michael   |


  @positive
  Scenario Outline: Update only lastname
    And I have created a booking
    When I update the created booking with lastname "<lastname>"
    Then the response status code should be 200
    And the response should contain updated lastname "<lastname>"

    Examples:
      | lastname |
      | Taylor   |


  @positive
  Scenario Outline: Update booking dates
    And I have created a booking
    When I update the created booking with checkin "<checkin>" and checkout "<checkout>"
    Then the response status code should be 200
    And the response should contain the updated booking dates

    Examples:
      | checkin    | checkout   |
      | 2024-09-01 | 2024-09-06 |


  @positive
  Scenario Outline: Update total price
    And I have created a booking
    When I update the created booking with total price <totalprice>
    Then the response status code should be 200
    And the response should contain updated total price <totalprice>

    Examples:
      | totalprice |
      | 300        |


  @negative @regression
  Scenario Outline: Update non-existing booking
    When I update booking ID <booking_id> with new booking details
    Then the response status code should be 404

    Examples:
      | booking_id |
      | 99999      |


  @negative @security
  Scenario Outline: Update booking with invalid token
    When I update booking ID <booking_id> with "<token_type>" token
    Then the response status code should be 401
    And the response should contain error message "Authentication required"

    Examples:
      | booking_id | token_type |
      | 1          | invalid    |
      | 1          | empty      |


  @negative @validation
  Scenario Outline: Update booking with invalid firstname
    And I have created a booking
    When I update the created booking with firstname "<firstname>"
    Then the response status code should be 400
    And the response should contain validation error "<expected_error>"

    Examples:
      | firstname                         | expected_error                |
      | Jo                                | size must be between 3 and 18 |
      | ThisIsAVeryLongFirstNameExceeding | size must be between 3 and 18 |


  @negative @validation
  Scenario Outline: Update booking with invalid lastname
    And I have created a booking
    When I update the created booking with lastname "<lastname>"
    Then the response status code should be 400
    And the response should contain validation error "<expected_error>"

    Examples:
      | lastname                          | expected_error                |
      | Li                                | size must be between 3 and 30 |
      | ThisIsAnExtremelyLongLastNameHere | size must be between 3 and 30 |


  @negative @validation
  Scenario Outline: Update booking with invalid date range
    And I have created a booking
    When I update the created booking with checkin "<checkin>" and checkout "<checkout>"
    Then the response status code should be 400
    And the response should contain validation error "<expected_error>"

    Examples:
      | checkin    | checkout   | expected_error                 |
      | 2024-10-10 | 2024-10-01 | checkout must be after checkin|