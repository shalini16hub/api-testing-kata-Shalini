@delete @positive

Feature: Delete booking via API

  Background:
    Given a booking exists

Scenario: Successfully delete an existing booking
  When I send a DELETE request to "/booking/{id}"
  Then the response status code should be 201
  And the booking should no longer be retrievable

@delete @negative
Scenario: Fail to delete a non-existing booking
  When I send a DELETE request to "/booking/99999"
  Then the response status code should be 404

@delete @negative
Scenario: Fail to delete booking with invalid ID format
  When I send a DELETE request to "/booking/abc"
  Then the response status code should be 400

@delete @negative @boundary
Scenario Outline: Fail to delete booking with invalid numeric IDs
  When I send a DELETE request to "/booking/<id>"
  Then the response status code should be 400

  Examples:
    | id              | description        |
    | 999999999999999 | extremely large ID |
    | 0               | zero ID            |

@delete @negative @validation
Scenario Outline: Fail to delete booking with invalid ID inputs
  When I send a DELETE request to "/booking/<id>"
  Then the response status code should be 400

  Examples:
    | id     | description              |
    | @#$%   | special characters in ID |
    |        | empty ID                 |

@delete @negative @security
Scenario: Fail to delete booking with XSS attempt
  When I send a DELETE request to "/booking/<script>alert('hack')</script>"
  Then the response status code should be 400

@delete @negative @contract
Scenario: Fail to delete booking with unsupported content type
  When I send a DELETE request to "/booking/{id}" with Content-Type "application/xml"
  Then the response status code should be 415

@delete @negative @auth
Scenario: Fail to delete booking without authentication
  When I send a DELETE request to "/booking/{id}" without valid auth token
  Then the response status code should be 403

@delete @negative @auth
Scenario Outline: Fail to delete booking with insufficient role permissions
  When I send a DELETE request to "/booking/{id}" as <role>
  Then the response status code should be 403

  Examples:
    | role      | description                  |
    | customer  | customer cannot delete       |
    | guest     | guest cannot delete          |
    | tester    | tester role not authorized   |

@delete @negative @concurrency
Scenario: Fail to delete booking that is already deleted
  Given a booking exists
  And I send a DELETE request to "/booking/{id}"
  When I send another DELETE request to "/booking/{id}"
  Then the response status code should be 404

@delete @negative @performance
Scenario: Fail to delete booking with too many requests
  Given a booking exists
  When I send 100 DELETE requests to "/booking/{id}" within 1 second
  Then the response status code should be 429
