@booking @api @positive @regression
Feature: Booking API Valid CRUD Flow

  As a user of the Booking API
  I want to create, retrieve, update and delete a booking
  So that I can manage reservations successfully


  @create @smoke
Scenario: Successfully create a booking with valid details
  When I send a POST request to "/booking" with the following payload:
    | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
    | John      | Doe      | 150        | true        | 2026-03-01  | 2026-03-05  |
  Then the response status code should be 200
  And the response should contain a booking ID
  And the response body should match the submitted booking details


  @retrieve
Scenario: Successfully retrieve the created booking using valid ID
  Given a booking exists
  When I send a GET request to "/booking/{id}"
  Then the response status code should be 200
  And the response body should contain the correct booking details


  @update
Scenario: Successfully update booking with valid authentication token
  Given a booking exists
  And I have a valid authentication token
  When I send a PUT request to "/booking/{id}" with the following payload:
    | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
    | Jane      | Smith    | 200        | false       | 2026-03-01  | 2026-03-05  |
  Then the response status code should be 200
  And the response body should reflect the updated booking details


  @delete
Scenario: Successfully delete booking with valid authentication token
  Given a booking exists
  And I have a valid authentication token
  When I send a DELETE request to "/booking/{id}"
  Then the response status code should be 201