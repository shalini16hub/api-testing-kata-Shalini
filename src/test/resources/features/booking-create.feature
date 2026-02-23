@booking @api @create
Feature : Create booking via API

As a customer
I want to create a hotel booking 
So that I can reserve a room successfully

Background:
  Given I have the booking API is available

  @positive @validation
  Scenario: Successfully create a booking with valid details
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID
    And the response body should match the submitted booking details
    And the response should follow the expected booking response structure

  @positive
  Scenario: Successfully create booking with short first name
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | J         | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID

  @positive
  Scenario: Successfully create booking with long first name
    When I send a POST request to "/booking" with the following payload:
      | firstname                     | lastname | totalprice | depositpaid | checkin    | checkout   |
      | JonathanChristopherAlexander  | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID

  @positive
  Scenario: Successfully create booking with short last name
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | D        | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID

  @positive
  Scenario: Successfully create booking with long last name
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname                      | totalprice | depositpaid | checkin    | checkout   |
      | John      | RobertsonWilliamsAnderson     | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID

  @positive
  Scenario: Successfully create booking when deposit is not paid
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | false       | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 200
    And the response should contain a booking ID

  @negative @validation
  Scenario: Fail to create booking when first name is missing
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      |           | Doe      | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 400
    And the error response should follow the expected error response structure

  @negative @validation
  Scenario: Fail to create booking when last name is missing
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      |          | 140        | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 400
    And the error response should follow the expected error response structure

  @negative @validation
  Scenario: Fail to create booking when total price is missing
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      |            | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 400

  @negative @validation
  Scenario: Fail to create booking when check-in date is missing
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin | checkout   |
      | John      | Doe      | 140        | true        |         | 2024-07-10 |
    Then the response status code should be 400

  @negative @validation
  Scenario: Fail to create booking when check-out date is missing
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout |
      | John      | Doe      | 140        | true        | 2024-07-01 |          |
    Then the response status code should be 400

  @negative @validation
  Scenario: Fail to create booking when total price is negative
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | -100       | true        | 2024-07-01 | 2024-07-10 |
    Then the response status code should be 400

  @negative @validation
  Scenario: Fail to create booking when check-in date is after check-out date
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-10 | 2024-07-01 |
    Then the response status code should be 400

  @negative @validation
  Scenario: Fail to create booking when check-in and check-out dates are the same
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin    | checkout   |
      | John      | Doe      | 140        | true        | 2024-07-01 | 2024-07-01 |
    Then the response status code should be 400




