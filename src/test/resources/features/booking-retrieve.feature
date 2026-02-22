@retrieve @positive @smoke
  Scenario: Successfully retrieve existing booking
    Given a booking exists
    When I send a GET request to "/booking/{id}"
    Then the response status code should be 200
    And the response body should contain the booking details

    @retrieve @positive @smoke
  Scenario: Successfully retrieve existing booking
    Given a booking exists
    When I send a GET request to "/booking/{id}"
    Then the response status code should be 200
    And the response body should contain the booking details

    @retrieve @positive
  Scenario: Retrieve all bookings
    When I send a GET request to "/booking"
    Then the response status code should be 200
    And the response should return a list of bookings

    @retrieve @negative
  Scenario: Fail to retrieve non-existing booking
    When I send a GET request to "/booking/99999"
    Then the response status code should be 404

    @retrieve @negative @validation
  Scenario: Fail to retrieve booking with invalid ID format
    When I send a GET request to "/booking/abc"
    Then the response status code should be 400