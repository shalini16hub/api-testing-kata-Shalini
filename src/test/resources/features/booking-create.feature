@booking @api @create
Feature: Create booking

  As a customer
  I want to request a reservation
  So that my stay can be confirmed by the reservations system

  Background:
    Given the reservations system is available


  @positive @validation
  Scenario Outline: Successfully create a booking with valid guest and stay details
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname   | lastname   | email   | phone   | totalprice   | depositpaid   | checkin   | checkout   |
      | <firstname> | <lastname> | <email> | <phone> | <totalprice> | <depositpaid> | <checkin> | <checkout> |
    When the booking request is submitted to the reservations system
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned to the caller
    And the confirmed booking record accurately reflects the submitted guest and stay details
    And the booking confirmation adheres to the expected response structure

    Examples:
      | firstname | lastname | email         | phone                 | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | john@test.com | 98765432101           | 140        | true        | 2026-03-01 | 2026-03-04 |
      | Sam       | Brown    | sam@test.com  | 98765432101           | 150        | true        | 2026-03-01 | 2026-03-04 |
      | Daniel    | Parker   | dan@test.com  | 123456789012345678901 | 180        | false       | 2026-03-04 | 2026-03-06 |



  @negative @validation
  Scenario Outline: Fail to create a booking when invalid guest or stay details are provided
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname   | lastname   | email   | phone   | totalprice   | depositpaid   | checkin   | checkout   |
      | <firstname> | <lastname> | <email> | <phone> | <totalprice> | <depositpaid> | <checkin> | <checkout> |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the validation error message indicates "<errorMessage>"

    Examples:
      | firstname | lastname             | email         | phone        | totalprice | depositpaid | checkin    | checkout   | errorMessage                              |
      | Jo        | Smith                | jo@test.com   | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-10 | firstname length is invalid               |
      | John      | VeryVeryLongLastName | john@test.com | 98765432101  | 140        | true        | 2026-03-06 | 2026-03-10 | lastname length is invalid                |
      | John      | Smith                | john@test.com | 123456789    | 140        | true        | 2026-03-01 | 2026-03-10 | phone number length is invalid            |
      | John      | Smith                | johnsm@ith    | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-10 | email address is invalid                  |
      | John      | Smith                | john@test.com | 98765432101  | 140        | true        | 2026-03-10 | 2026-03-01 | stay dates are invalid                    |
      | John      | Smith                | john@test.com | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-01 | stay dates are invalid                    |


