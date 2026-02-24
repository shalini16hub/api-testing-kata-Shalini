@booking @api @create
Feature: Create booking

  As a customer
  I want to request a hotel reservation
  So that I can successfully reserve a room

  Background:
    Given the reservation system is available


  @positive @validation
  Scenario: Successfully create a booking with valid guest and stay details
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned
    And the confirmed booking record accurately reflects the submitted guest and stay details
    And the booking confirmation adheres to the expected response structure


  @positive
  Scenario: Successfully create a booking with a short first name
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | J         | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @positive
  Scenario: Successfully create a booking with a long first name
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname                    | lastname | totalprice | depositpaid | checkin    | checkout   |
      | JonathanChristopherAlexander | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @positive
  Scenario: Successfully create a booking with a short last name
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | D        | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @positive
  Scenario: Successfully create a booking with a long last name
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname                  | totalprice | depositpaid | checkin    | checkout   |
      | John      | RobertsonWilliamsAnderson | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @positive
  Scenario: Successfully create a booking when deposit is not paid
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | false       | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @negative @validation
  Scenario: Fail to create a booking when the first name is missing
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      |           | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the last name is missing
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      |          | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the total price is missing
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      |            | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the check-in date is missing
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin | checkout   |
      | John      | Doe      | 140        | true        |         | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the check-out date is missing
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout |
      | John      | Doe      | 140        | true        | 2024-07-01 |          |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the total price is negative
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | -100       | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the check-in date is after the check-out date
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-10 | 2024-07-01 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the check-in and check-out dates are the same
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-01 | 2024-07-01 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error

  @positive
  Scenario: Successfully create a booking with a decimal total price
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140.50     | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned


  @negative @validation
  Scenario: Fail to create a booking when the total price is zero
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 0          | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the first name contains only spaces
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      |           | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the last name contains special characters
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | @@@@     | 140        | true        | 2024-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @negative @validation
  Scenario: Fail to create a booking when the check-in date is in the past
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2022-07-01 | 2024-07-10 |
    When the reservation request is submitted
    Then the system rejects the reservation request
    And the response indicates a validation error


  @positive
  Scenario: Successfully create multiple bookings for the same guest on different dates
    Given a reservation is requested with the following confirmed guest and stay details:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-01 | 2024-07-05 |
    When the reservation request is submitted
    Then the system acknowledges the request with a successful response
    And a unique booking reference ID is generated and returned



