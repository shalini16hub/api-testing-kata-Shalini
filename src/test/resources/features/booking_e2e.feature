@e2e @booking @ui
Feature: End-to-end hotel room booking from customer booking page

  Business Objective:
  A customer should be able to search and reserve a hotel room from the booking page
  by providing their personal details and stay dates, and receive a clear confirmation
  when the reservation is accepted by the hotel system.

  Business Rules:
  - A booking can be created only when mandatory customer and stay details are provided.
  - Stay dates must be valid and must not be in the past.
  - Check-out date must be after check-in date.
  - The selected room type must be available for the requested dates.
  - Customer contact details must be valid so that the hotel can reach the guest.
  - Once a booking is submitted, the system must reserve the room and generate a booking reference.

  Background:
    Given the customer is on the hotel booking page


  @positive @sanity
  Scenario Outline: Customer successfully books a room from the booking page
    When the customer enters first name "<firstname>"
    And the customer enters last name "<lastname>"
    And the customer enters email "<email>"
    And the customer enters phone number "<phone>"
    And the customer selects check-in date "<checkin>"
    And the customer selects check-out date "<checkout>"
    And the customer enters special requests "<notes>"
    And the customer submits the booking request
    And the system validates the customer details and requested stay dates
    And the system checks room availability for the selected dates
    And the system creates a reservation and assigns a booking reference
    Then the customer should see a booking confirmation
    And the booking details should be visible to the customer

    Examples:
      | firstname | lastname | email          | phone      | checkin     | checkout    | notes            |
      | John      | Smith    | john@test.com  | 9876543210 | 2026-03-10  | 2026-03-12  | Near lift please |
      | Anita     | Kumar    | anita@test.com | 9123456789 | 2026-03-15  | 2026-03-18  | High floor room  |


  @negative @validation
  Scenario Outline: Booking is rejected when mandatory information is missing
    When the customer enters first name "<firstname>"
    And the customer enters last name "<lastname>"
    And the customer enters email "<email>"
    And the customer enters phone number "<phone>"
    And the customer selects check-in date "<checkin>"
    And the customer selects check-out date "<checkout>"
    And the customer submits the booking request
    And the system validates mandatory booking information
    Then the customer should be informed that mandatory details are missing
    And the booking should not be created

    Examples:
      | firstname | lastname | email         | phone      | checkin     | checkout    |
      |           | Smith    | john@test.com | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      |          | john@test.com | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      | Smith    |               | 9876543210 | 2026-03-10  | 2026-03-12  |
      | John      | Smith    | john@test.com |            | 2026-03-10  | 2026-03-12  |


  @negative @validation
  Scenario Outline: Booking is rejected when contact details are invalid
    When the customer enters first name "<firstname>"
    And the customer enters last name "<lastname>"
    And the customer enters email "<email>"
    And the customer enters phone number "<phone>"
    And the customer selects check-in date "<checkin>"
    And the customer selects check-out date "<checkout>"
    And the customer submits the booking request
    And the system validates customer contact details
    Then the customer should be informed that the contact information is invalid
    And the booking should not be created

    Examples:
      | firstname | lastname | email       | phone | checkin     | checkout    |
      | John      | Smith    | wrongemail  | 98765 | 2026-03-10  | 2026-03-12  |


  @positive @roomtype
  Scenario Outline: Customer successfully books different room types
    When the customer selects room type "<roomType>"
    And the customer enters first name "<firstname>"
    And the customer enters last name "<lastname>"
    And the customer enters email "<email>"
    And the customer enters phone number "<phone>"
    And the customer selects check-in date "<checkin>"
    And the customer selects check-out date "<checkout>"
    And the customer submits the booking request
    And the system verifies availability for room type "<roomType>"
    And the system creates the booking for the selected room type
    Then the customer should see a booking confirmation
    And the confirmed booking should show room type "<roomType>"

    Examples:
      | roomType | firstname | lastname | email           | phone      | checkin     | checkout    |
      | Single   | John      | Smith    | john@test.com   | 9876543210 | 2026-03-10  | 2026-03-12  |
      | Double   | Anita     | Kumar    | anita@test.com  | 9123456789 | 2026-03-15  | 2026-03-17  |
      | Suite    | Rahul     | Verma    | rahul@test.com  | 9988776655 | 2026-03-20  | 2026-03-23  |


  @positive @roomtype
  Scenario Outline: Booking confirmation displays the selected room type
    When the customer selects room type "<roomType>"
    And the customer completes the booking with valid personal and stay details
    And the system confirms the reservation
    Then the booking confirmation should display room type "<roomType>"

    Examples:
      | roomType |
      | Single   |
      | Double   |
      | Suite    |


  @negative @business
  Scenario Outline: Booking is rejected when check-out date is before check-in date
    When the customer provides check-in date "<checkin>" and check-out date "<checkout>"
    And the customer submits the booking request
    And the system validates the stay period
    Then the customer should be informed that the stay dates are invalid
    And the booking should not be created

    Examples:
      | checkin     | checkout    |
      | 2026-03-12  | 2026-03-10  |


  @negative @business
  Scenario Outline: Booking is rejected when the stay starts in the past
    When the customer selects check-in date "<checkin>" and check-out date "<checkout>"
    And the customer submits the booking request
    And the system validates that the stay dates are not in the past
    Then the customer should be informed that past dates cannot be booked
    And the booking should not be created

    Examples:
      | checkin     | checkout    |
      | 2024-01-10  | 2024-01-12  |


  @negative @availability
  Scenario Outline: Booking is rejected when the selected room type is not available
    When the customer selects room type "<roomType>"
    And the customer selects check-in date "<checkin>" and check-out date "<checkout>"
    And the customer submits the booking request
    And the system checks availability for the selected room type
    Then the customer should be informed that the selected room is not available
    And the booking should not be created

    Examples:
      | roomType | checkin     | checkout    |
      | Suite    | 2026-12-24  | 2026-12-26  |


  @negative @business
  Scenario Outline: Booking is rejected when the requested stay overlaps with a fully booked period
    When the customer selects room type "<roomType>"
    And the customer selects check-in date "<checkin>" and check-out date "<checkout>"
    And the customer submits the booking request
    And the system verifies overlapping reservations for the same room type
    Then the customer should be informed that the selected dates are unavailable
    And the booking should not be created

    Examples:
      | roomType | checkin     | checkout    |
      | Double   | 2026-03-16  | 2026-03-17  |


  @business @usability
  Scenario Outline: Customer can submit a booking without optional notes
    When the customer enters first name "<firstname>"
    And the customer enters last name "<lastname>"
    And the customer enters email "<email>"
    And the customer enters phone number "<phone>"
    And the customer selects check-in date "<checkin>"
    And the customer selects check-out date "<checkout>"
    And the customer submits the booking request without entering notes
    And the system validates the booking and creates a reservation
    Then the customer should see a booking confirmation

    Examples:
      | firstname | lastname | email         | phone      | checkin     | checkout    |
      | Neha      | Sharma   | neha@test.com | 9000011111 | 2026-04-05  | 2026-04-07  |


  @business @concurrency
  Scenario Outline: Booking is rejected when another customer completes the last available room first
    When two customers attempt to book room type "<roomType>" for the same dates
    And the first customer successfully completes the booking
    And the second customer submits the booking request
    And the system rechecks availability before confirming the second request
    Then the second customer should be informed that the room is no longer available
    And only one booking should be created for that room type and date range

    Examples:
      | roomType |
      | Single   |