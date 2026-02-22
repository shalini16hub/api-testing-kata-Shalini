@update @positive @regression
  Scenario: Successfully update booking with valid token
    Given a booking exists
    And I have a valid authentication token
    When I send a PUT request to "/booking/{id}" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      | Jane      | Smith    | 200        | false       | 2024-08-01  | 2024-08-05  |
    Then the response status code should be 200
    And the response body should reflect the updated booking details


     @update @negative @auth
  Scenario: Fail to update booking without authentication
    Given a booking exists
    When I send a PUT request to "/booking/{id}" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      | Jane      | Smith    | 200        | false       | 2024-08-01  | 2024-08-05  |
    Then the response status code should be 403

    @update @negative @validation
  Scenario: Fail to update booking with invalid data
    Given a booking exists
    And I have a valid authentication token
    When I send a PUT request to "/booking/{id}" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      |           | Smith    | -50        | false       | 2024-08-10  | 2024-08-01  |
    Then the response status code should be 400

    @update @negative
  Scenario: Fail to update non-existing booking
    Given I have a valid authentication token
    When I send a PUT request to "/booking/99999" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      | Jane      | Smith    | 200        | false       | 2024-08-01  | 2024-08-05  |
    Then the response status code should be 404