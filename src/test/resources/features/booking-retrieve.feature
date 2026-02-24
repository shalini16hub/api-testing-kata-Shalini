@retrieve
Feature: Retrieve future bookings

  As a customer
  I want to view my future reservation details
  So that I can verify my upcoming booking information

  Background:
    Given the reservation system is available
    And today’s date is before "2026-07-01"


  @retrieve @positive
  Scenario: Successfully retrieve a future booking using a valid booking reference
    Given a confirmed future booking exists with the following details:
      | bookingreference | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | 101              | John      | Doe      | 140        | true        | 2026-07-01 | 2026-07-10 |
    When a request is made to view a booking using the following booking reference:
      | bookingreference |
      | 101              |
    Then the system returns the booking details
    And the returned booking information accurately reflects the stored booking record
    And the booking details adhere to the expected response structure


  @retrieve @positive @filter
  Scenario: Successfully retrieve future bookings filtered by first name
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | firstname |
      | John      |
    Then the system returns only future bookings with first name "John"


  @retrieve @positive @filter
  Scenario: Successfully retrieve future bookings filtered by last name
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | lastname |
      | Doe      |
    Then the system returns only future bookings with last name "Doe"


  @retrieve @positive @filter
  Scenario: Successfully retrieve future bookings filtered by check-in date
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | checkin    |
      | 2026-07-01 |
    Then the system returns only future bookings with check-in date "2026-07-01"


  @retrieve @positive @filter
  Scenario: Successfully retrieve future bookings filtered by first name and last name
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | firstname | lastname |
      | John      | Doe      |
    Then the system returns only future bookings matching the provided first name and last name


  @retrieve @positive @filter
  Scenario: Successfully retrieve future bookings filtered by a date range
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | fromdate   | todate     |
      | 2026-07-01 | 2026-07-10 |
    Then the system returns only bookings that fall within the provided future date range


  @retrieve @negative @boundary
  Scenario Outline: Fail to retrieve a future booking using invalid numeric booking references
    Given the booking reference provided is:
      | bookingreference |
      | <id>             |
    When a request is made to view the booking
    Then the system rejects the request
    And the response indicates a validation error

    Examples:
      | id              |
      | 999999999999999 |
      | 0               |


  @retrieve @negative @validation
  Scenario Outline: Fail to retrieve a future booking using an invalid booking reference format
    Given the booking reference provided is:
      | bookingreference |
      | <id>             |
    When a request is made to view the booking
    Then the system rejects the request
    And the response indicates a validation error

    Examples:
      | id   |
      | abc  |
      | @#$% |
      |      |


  @retrieve @negative
  Scenario: Fail to retrieve a future booking when the booking reference does not exist
    Given no future booking exists for the following booking reference:
      | bookingreference |
      | 99999            |
    When a request is made to view the booking
    Then the system rejects the request
    And the response indicates that the booking could not be found


  @retrieve @negative @validation
  Scenario: Fail to retrieve future bookings when invalid filter values are provided
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | checkin |
      | abc     |
    Then the system rejects the request
    And the response indicates a validation error


  @retrieve @negative @contract
  Scenario: Fail to retrieve a future booking when an unsupported response format is requested
    Given an unsupported response format is requested
    When a request is made to view a booking
    Then the system rejects the request
    And the response indicates that the requested format is not supported


  @retrieve @positive
  Scenario: Successfully retrieve multiple future bookings when no filter criteria are provided
    Given multiple future bookings exist in the reservation system
    When a request is made to view all available future bookings
    Then the system returns the list of future bookings
    And each returned booking contains the required booking details