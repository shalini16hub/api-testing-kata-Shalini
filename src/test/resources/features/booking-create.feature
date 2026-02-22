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
	| firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
	| John      | Doe      | 140        | true        | 2024-07-01  | 2024-07-10  |
  Then the response status code should be 200
  And the response should contain a booking ID
  And the response body should match the submitted booking details

   @create @negative @validation
  Scenario: Fail to create booking with missing required fields
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin | checkout |
      | John      |          | 140        | true        |         |          |
    Then the response status code should be 400


    @create @negative @validation
  Scenario: Fail to create booking with invalid date range
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      | John      | Doe      | 140        | true        | 2024-07-10  | 2024-07-01  |
    Then the response status code should be 400

 @create @negative @validation
  Scenario: Fail to create booking with negative total price
    When I send a POST request to "/booking" with the following payload:
      | firstname | lastname | totalprice | depositpaid | checkin     | checkout    |
      | John      | Doe      | -100       | true        | 2024-07-01  | 2024-07-10  |
    Then the response status code should be 400

 @create @negative @boundary
  Scenario: Fail to create booking with extremely long names
    When I send a POST request to "/booking" with the following payload:
      | firstname                                | lastname                                 | totalprice | depositpaid | checkin     | checkout    |
      | AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA | BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB | 140        | true        | 2024-07-01  | 2024-07-10  |
    Then the response status code should be 400




