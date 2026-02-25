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
    When a request is made to view a booking using booking reference "101"
    Then the system returns the booking details
    And the returned booking information accurately reflects the stored booking record
    And the booking details adhere to the expected response structure


  @retrieve @positive
  Scenario: Successfully retrieve multiple future bookings when no filter criteria are provided
    Given multiple future bookings exist in the reservation system
    When a request is made to view all available future bookings
    Then the system returns the list of future bookings
    And each returned booking contains the required booking details


  @retrieve @positive @filter
  Scenario Outline: Successfully retrieve future bookings using valid filter criteria
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | firstname | lastname | checkin    | fromdate | todate |
      | <fn>      | <ln>     | <checkin> | <from>  | <to>   |
    Then only the matching future bookings are returned

    Examples:
      | fn   | ln  | checkin    | from       | to         |
      | John |     |            |            |            |
      |      | Doe |            |            |            |
      |      |     | 2026-07-01 |            |            |
      | John | Doe |            |            |            |
      |      |     |            | 2026-07-01 | 2026-07-10 |


  @retrieve @negative @validation
  Scenario Outline: Fail to retrieve a future booking when the booking reference is invalid
    Given the booking reference provided is "<bookingReference>"
    When a request is made to view the booking
    Then the system rejects the request
    And the response indicates a validation error

    Examples:
      | bookingReference |
      | 999999999999999  |
      | 0                |
      | abc              |
      | @#$%             |
      |                  |


  @retrieve @negative @notfound
  Scenario: Fail to retrieve a future booking when the booking reference does not exist
    Given no future booking exists for booking reference "99999"
    When a request is made to view the booking
    Then the system rejects the request
    And the response indicates that the booking could not be found


  @retrieve @negative @validation
  Scenario Outline: Fail to retrieve future bookings when invalid filter values are provided
    Given multiple future bookings exist in the reservation system
    When a request is made to view bookings using the following filter criteria:
      | firstname | lastname | checkin    | fromdate | todate |
      | <fn>      | <ln>     | <checkin> | <from>  | <to>   |
    Then the system rejects the request
    And the response indicates a validation error

    Examples:
      | fn   | ln  | checkin | from | to |
      |      |     | abc     |      |    |
      | John |     |         | bad  |    |
      |      | Doe |         |      | bad |


  @retrieve @negative @contract
  Scenario: Fail to retrieve future bookings when an unsupported response format is requested
    Given an unsupported response format is requested
    When a request is made to view future bookings
    Then the system rejects the request
    And the response indicates that the requested format is not supported