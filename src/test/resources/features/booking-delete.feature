@delete @positive
Feature: Cancel booking

  As a customer
  I want to cancel an existing reservation
  So that the booking is no longer active

  Background:
    Given a confirmed booking already exists in the reservation system

  @delete @positive
  Scenario: Successfully cancel an existing booking
    When a cancellation request is submitted for the existing booking
    Then the system acknowledges the cancellation request
    And the booking is successfully removed from the system
    And the booking can no longer be retrieved


  @delete @negative
  Scenario: Fail to cancel a booking that does not exist
    Given no booking exists for the requested booking reference
    When a cancellation request is submitted
    Then the system rejects the cancellation request
    And the response indicates that the booking could not be found


  @delete @negative @validation
Scenario Outline: Fail to cancel a booking when the booking reference is invalid
  Given the booking reference provided is <bookingReference>
  When a cancellation request is submitted
  Then the system rejects the cancellation request
  And the response indicates a validation error

  Examples:
    | bookingReference |
    | invalidFormat    |
    | 999999999999999  |
    | 0                |
    | @#$%             |
    |                  |


@delete @negative @security
  Scenario: Fail to cancel a booking when a malicious booking reference is submitted
    Given a malicious booking reference is provided
    When a cancellation request is submitted
    Then the system rejects the cancellation request
    And the response indicates a validation error


  @delete @negative @contract
  Scenario: Fail to cancel a booking when the request format is not supported
    Given the cancellation request is submitted in an unsupported format
    When a cancellation request is submitted
    Then the system rejects the cancellation request
    And the response indicates an unsupported request format


  @delete @negative @auth
  Scenario: Fail to cancel a booking when the user is not authenticated
    Given the user is not authenticated
    When a cancellation request is submitted for an existing booking
    Then the system rejects the cancellation request
    And the response indicates that access is not permitted


  @delete @negative @auth
  Scenario Outline: Fail to cancel a booking when the user does not have sufficient permission
    Given the user is logged in with the role <role>
    And a confirmed booking exists
    When a cancellation request is submitted
    Then the system rejects the cancellation request
    And the response indicates that the user is not authorised to cancel the booking

    Examples:
      | role     |
      | customer |
      | guest    |
      | tester   |


  @delete @negative @concurrency
  Scenario: Fail to cancel a booking that has already been cancelled
    Given a confirmed booking exists
    And the booking has already been cancelled
    When a cancellation request is submitted again for the same booking
    Then the system rejects the cancellation request
    And the response indicates that the booking could not be found


  @delete @negative @performance
  Scenario: Fail to cancel a booking when too many cancellation requests are submitted in a short period
    Given a confirmed booking exists
    When multiple cancellation requests are submitted for the same booking in a very short time
    Then the system rejects the excess cancellation requests
    And the response indicates that the request rate limit has been exceeded

