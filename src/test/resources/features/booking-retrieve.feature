@retrieve @positive
Feature : Retrieve booking via API

Background:
  Given I have the booking service is available

Scenario: Retrieve booking by valid ID
  When I send a GET request to "/booking/{id}"
  Then the response status code should be 200
  And the response body should contain the booking details

@retrieve @positive @filter
Scenario: Retrieve bookings filtered by firstname
  When I send a GET request to "/booking?firstname=John"
  Then the response status code should be 200
  And the response should return only bookings with firstname "John"

@retrieve @positive @filter
Scenario: Retrieve bookings filtered by checkin date
  When I send a GET request to "/booking?checkin=2024-07-01"
  Then the response status code should be 200
  And the response should return only bookings with checkin date "2024-07-01"

@retrieve @negative @boundary
Scenario Outline: Fail to retrieve booking with invalid numeric IDs
  When I send a GET request to "/booking/<id>"
  Then the response status code should be 400

  Examples:
    | id              | description        |
    | 999999999999999 | extremely large ID |
    | 0               | zero ID            |

@retrieve @negative
Scenario Outline: Fail to retrieve booking with invalid ID formats
  When I send a GET request to "/booking/<id>"
  Then the response status code should be 400

  Examples:
    | id     | description              |
    | abc    | alphabetic ID            |
    | @#$%   | special characters in ID |
    |        | empty ID                 |


@retrieve @negative @contract
Scenario: Fail to retrieve booking with unsupported Accept header
  When I send a GET request to "/booking/{id}" with Accept header "application/xml"
  Then the response status code should be 406

