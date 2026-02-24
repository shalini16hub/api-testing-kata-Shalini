@booking @api @create
Feature: Create booking

  As a customer
  I want to request a reservation
  So that my stay can be confirmed by the reservations system

  Background:
    Given the reservations system is available


  @positive @validation
  Scenario: Successfully create a booking with valid guest and stay details
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email           | phone        | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | john@test.com   | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-04 |
    When the booking request is submitted to the reservations system
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned to the caller
    And the confirmed booking record accurately reflects the submitted guest and stay details
    And the booking confirmation adheres to the expected response structure


  @positive @validation
  Scenario: Successfully create a booking when the firstname is at the minimum allowed length
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email         | phone        | totalprice | depositpaid | checkin    | checkout   |
      | Sam       | Brown    | sam@test.com  | 98765432101  | 150        | true        | 2026-03-01 | 2026-03-04 |
    When the booking request is submitted to the reservations system
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned to the caller


  @positive @validation
  Scenario: Successfully create a booking when the phone number is at the maximum allowed length
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email          | phone                 | totalprice | depositpaid | checkin    | checkout   |
      | Daniel    | Parker   | dan@test.com   | 123456789012345678901 | 180        | false       | 2026-03-04 | 2026-03-06 | 
    When the booking request is submitted to the reservations system
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned to the caller


  @negative @validation
  Scenario: Fail to create a booking when the firstname is shorter than the allowed length
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email        | phone        | totalprice | depositpaid | checkin    | checkout   |
      | Jo        | Smith    | jo@test.com  | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-10 |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the validation error message indicates that the firstname length is invalid


  @negative @validation
  Scenario: Fail to create a booking when the lastname is longer than the allowed length
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname                | email         | phone        | totalprice | depositpaid | checkin    | checkout   |
      | John      | VeryVeryLongLastName    | john@test.com | 98765432101  | 140        | true        | 2026-03-06 | 2026-03-10 |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the validation error message indicates that the lastname length is invalid


  @negative @validation
  Scenario: Fail to create a booking when the phone number is shorter than the allowed length
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email        | phone     | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | john@test.com| 123456789 | 140        | true        | 2026-03-01 | 2026-03-10 |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the validation error message indicates that the phone number length is invalid


  @negative @validation
  Scenario: Fail to create a booking when the email address is not well formed
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email      | phone        | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | johnsm@ith  | 98765432101  | 140        | true       | 2026-03-01 |2026-03-10  |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the validation error message indicates that the email address is invalid


  @negative @validation
  Scenario: Fail to create a booking when the checkout date is before the checkin date
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email         | phone        | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | john@test.com | 98765432101  | 140        | true        | 2026-03-10 | 2026-03-01 |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the booking cannot be created because the stay dates are invalid


  @negative @validation
  Scenario: Fail to create a booking when the checkout date is the same as the checkin date
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | email         | phone        | totalprice | depositpaid | checkin    | checkout   |
      | John      | Smith    | john@test.com | 98765432101  | 140        | true        | 2026-03-01 | 2026-03-01 |
    When the booking request is submitted to the reservations system
    Then the system rejects the booking request due to validation errors
    And the booking cannot be created because the stay dates are invalid



