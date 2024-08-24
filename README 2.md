# User-Changes-Xpress

## Overview

This application provides an API for tracking changes to records, specifically focusing on recording changes for various fields associated with a user. It supports tracking changes in a versioned manner and allows querying these changes over specific date ranges.

## Features

 - Track Changes: Track old and new values of specified fields for a user.
 - Filter Changes: Query changes based on date ranges and specific fields.
 - API-First: Built with a focus on providing a clean and robust API.

## Requirements

 - Ruby 3.0.2
 - Rails 6.1.7.8
 - SQLite (for development and testing)

## Getting Started

### Install the dependencies:

```sh
  gem install bundler
  gem bundle install
```
## API Endpoints
1. Track Changes

 - Endpoint: POST /api/v1/changes
 - Description: Tracks changes for a user's fields.
 - Request Body:

```json
{
  "user_id": 1,
  "old": {"name": "Bruce Norries", "address": {"street": "Some street"}},
  "new": {"name": "Bruce Willis", "address": {"street": "Nakatomi Plaza"}}
}
```

- Reponse:

```json
{
  "message": "Changes tracked successfully"
}
```

2. Get Changes

 - Endpoint: GET /api/v1/changes
 - Description: Retrieves changes based on a date range and an optional field filter.
 - Query Parameters:
    -> start_date (optional): Start date for filtering changes.
    -> end_date (optional): End date for filtering changes.
    -> ield (optional): Specific field to filter by.

 - Example:
```sh
  curl -X GET "http://localhost:3000/api/v1/changes?start_date=2024-08-01T00:00:00Z&end_date=2024-08-31T23:59:59Z&field=name"

```

 - Reponse:

```json
[
  {
    "field": "name",
    "old": "Bruce Norries",
    "new": "Bruce Willis"
  }
]
```

## Running Tests

This project uses RSpec for testing. To run the tests, follow these steps:
1. Set up the test database:

```sh
rails db:migrate RAILS_ENV=test
```

2. Run the tests:

```sh
bundle exec rspec
```

This will run all the RSpec tests in the spec/ directory.
