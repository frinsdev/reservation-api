# Reservation API

A Ruby on Rails API application that handles multiple reservation payload formats through a single endpoint.

## System Requirements

- Ruby 3.2.2
- Rails 7.1.x
- PostgreSQL

## Setup

1. Clone the repository

```bash
git clone <repository-url>
cd <repository-name>
```

2. Install dependencies

```bash
bundle install
```

3. Database setup

```bash
rails db:create
rails db:migrate
```

## Running the Application

Start the Rails server:

```bash
rails server
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Create Reservation

**POST** `/reservations`

Accepts reservation payloads in different formats and creates a reservation with associated guest information.

#### Sample Payloads

Format 1 (Direct):

```json
{
  "start_date": "2021-03-12",
  "end_date": "2021-03-16",
  "nights": 4,
  "guests": 4,
  "adults": 2,
  "children": 2,
  "infants": 0,
  "status": "accepted",
  "guest": {
    "id": 1,
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "phone": "639123456789",
    "email": "wayne_woodbridge@bnb.com"
  },
  "currency": "AUD",
  "payout_price": "3800.00",
  "security_price": "500",
  "total_price": "4500.00"
}
```

Format 2 (Nested):

```json
{
  "reservation": {
    "start_date": "2021-03-12",
    "end_date": "2021-03-16",
    "expected_payout_amount": "3800.00",
    "guest_details": {
      "localized_description": "4 guests",
      "number_of_adults": 2,
      "number_of_children": 2,
      "number_of_infants": 0
    },
    "guest_email": "wayne_woodbridge@bnb.com",
    "guest_first_name": "Wayne",
    "guest_id": 1,
    "guest_last_name": "Woodbridge",
    "guest_phone_numbers": ["639123456789", "639987654321"],
    "listing_security_price_accurate": "500.00",
    "host_currency": "AUD",
    "nights": 4,
    "number_of_guests": 4,
    "status_type": "accepted",
    "total_paid_amount_accurate": "4500.00"
  }
}
```

## Adding New Payload Formats

The application uses a YAML-based configuration system to handle different payload formats. To add support for a new format:

1. Open `config/payload_mappings.yml`
2. Add a new format configuration following this structure:

```yaml
formats:
  new_format_name:
    # Define the expected structure to identify this format
    structure:
      key1: {}
      key2:
        nested_key: {}

    # Define the mappings for guest and reservation fields
    mappings:
      guest:
        email: "path.to.email"
        first_name: "path.to.first_name"
        last_name: "path.to.last_name"
        phone_numbers: "path.to.phone_numbers"

      reservation:
        start_date: "path.to.start_date"
        end_date: "path.to.end_date"
        nights: "path.to.nights"
        guests: "path.to.guests"
        adults: "path.to.adults"
        children: "path.to.children"
        infants: "path.to.infants"
        status: "path.to.status"
        currency: "path.to.currency"
        payout_price: "path.to.payout_price"
        security_price: "path.to.security_price"
        total_price: "path.to.total_price"
```

The `structure` section defines the expected payload structure used to identify the format. The `mappings` section defines the paths to extract specific fields from the payload.

Use dot notation to specify nested paths (e.g., "reservation.guest_details.number_of_adults").

## Running Tests

```bash
rails test
```

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- 201 Created: Successful reservation creation
- 422 Unprocessable Entity: Invalid payload or validation errors
