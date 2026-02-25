@delete
Feature: Cancel booking

  As a customer
  I want to cancel an existing reservation
  So that the booking is no longer active

  Background:
    Given the reservation system is available


  @delete @positive
  Scenario: Successfully cancel an existing booking
    Given a confirmed booking exists
    When a cancellation request is submitted for that booking
    Then the cancellation is accepted
    And the booking is removed
    And the booking can no longer be retrieved



  @delete @negative @notfound
  Scenario Outline: Fail to cancel a booking when the booking cannot be found
    Given a booking with reference <bookingReference> does not exist
    When a cancellation request is submitted
    Then the cancellation is rejected
    And the response indicates that the booking was not found

    Examples:
      | bookingReference |
      | 999999999999999  |
      | alreadyCancelled |



  @delete @negative @validation
  Scenario Outline: Fail to cancel a booking when the booking reference is invalid
    Given the booking reference is <bookingReference>
    When a cancellation request is submitted
    Then the cancellation is rejected
    And the response indicates a validation error

    Examples:
      | bookingReference |
      | invalidFormat    |
      | 0                |
      | @#$%             |
      |                  |



  @delete @negative @security
  Scenario Outline: Fail to cancel a booking when a malicious booking reference is submitted
    Given the booking reference is <bookingReference>
    When a cancellation request is submitted
    Then the cancellation is rejected
    And the response indicates a validation error

    Examples:
      | bookingReference                |
      | <script>alert(1)</script>      |
      | ' OR '1'='1                    |



  @delete @negative @auth
  Scenario Outline: Fail to cancel a booking when the user is not authorised to cancel
    Given the user context is <userContext>
    And a confirmed booking exists
    When a cancellation request is submitted
    Then the cancellation is rejected
    And the response indicates that access is not permitted

    Examples:
      | userContext      |
      | unauthenticated  |
      | customer         |
      | guest            |
      | tester           |



  @delete @negative @contract
  Scenario: Fail to cancel a booking when the request format is not supported
    Given the cancellation request is submitted in an unsupported format
    When a cancellation request is submitted
    Then the cancellation is rejected
    And the response indicates an unsupported request format



  @delete @negative @performance
  Scenario: Fail to cancel a booking when too many cancellation requests are submitted in a short time
    Given a confirmed booking exists
    When multiple cancellation requests are submitted for the same booking in a short time
    Then the excess cancellation requests are rejected
    And the response indicates that the request rate limit has been exceeded

