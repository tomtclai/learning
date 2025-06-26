# Travel Journey API

The Travel Journey API is a backend service designed for the Udacity iOS Nanodegree Program. It provides a platform for students to document and manage their travel experiences.

## Features

The API supports a range of features including:

- User authentication
- Trip management
- Event management

## Getting Started

To get started with the Travel Journey API, follow these steps:

1. Clone the repository to your local machine.
2. Ensure [Docker](https://docs.docker.com/desktop/) is installed on your device and the Docker service is running.
3. Create an `.env` file in the main directory. You can use the provided `.env.example` as a template. 

## Running the Application

To run the application, use the following command:

```sh
docker-compose up --build
```

Once the application is running, you can access the API at [http://localhost:8000](http://localhost:8000).

Test that the server is working with a curl request to the server root:

```sh
curl http://localhost:8000
```

You should receive a response similar to the following:

```json
{"message":"Hello, World!"}
```

## Documentation
Detailed API specifications and interactive testing are available via Swagger at [http://localhost:8000/docs](http://localhost:8000/docs).


## API Endpoints

### Authentication

#### **User Registration**: `POST /register` - Register a new user.

Curl Example
```sh
curl -X 'POST' \
'http://localhost:8000/register' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
  "username": "your_username",
  "password": "your_password"
}'
```

#### **User Login**: `POST /token` - Log in as a user and receive a token for authenticated API interactions..

Curl Example
```sh
curl -X 'POST' \
  'http://localhost:8000/token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=&username=your_username&password=your_password'
```

---

### Trip Management

#### **Create a Trip**: `POST /trips` - Create a new trip.

Curl Example

```sh
curl -X 'POST' \
'http://localhost:8000/trips' \
-H 'accept: application/json' \
-H 'Authorization: Bearer your_token' \
-H 'Content-Type: application/json' \
-d '{
  "name": "trip_name",
  "start_date": "trip_start_date_in_iso8061_format",
  "end_date": "trip_end_date_in_iso8061_format"
}'
```

#### **Read Trips**: `GET /trips` - Get a list of all trips for a user.

Curl Example

```sh
curl -X 'GET' \
'http://localhost:8000/trips' \
-H 'accept: application/json' \
-H 'Authorization: Bearer your_token'
```

#### **Read Trips**: `GET /trips/{tripId}` - Get details of a specific trip.

Curl Example

```sh
curl -X 'GET' \
'http://localhost:8000/trips/trip_id' \
-H 'accept: application/json' \
-H 'Authorization: Bearer your_token'
```

#### **Update a Trip**: `PUT /trips/{tripId}` - Update a specific trip.

Curl Example

```sh
curl -X 'PUT' \
  'http://localhost:8000/trips/trip_id' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer your_token' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "trip_name",
  "start_date": "trip_start_date_in_iso8061_format",
  "end_date": "trip_end_date_in_iso8061_format"
}'
```

#### **Delete a Trip**: `DELETE /trips/{tripId}` - Delete a specific trip.

Curl Example

```sh
curl -X 'DELETE' \
  'http://localhost:8000/trips/trip_id' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer your_token'
```

---

### Event Management

#### **Create an Event**: `POST /events` - Add a new event.

Curl Example

```sh
curl -X 'POST' \
  'http://localhost:8000/events' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer your_token' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "event_name",
  "date": "event_date_in_iso8061_format",
  "location": {
    "latitude": double_lat,
    "longitude": double_long,
    "address": "optional_address"
  },
  "transition_from_previous": "optional_string",
  "trip_id": trip_id
}'
```

#### **Read Events**: `GET /events/{eventId}` - Get details of a specific event.

Curl Example

```sh
curl -X 'GET' \
  'http://localhost:8000/events/event_id' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer your_token'
```

#### **Update an Event**: `PUT /events/{eventId}` - Update a specific event.

Curl Example

```sh
curl -X 'PUT' \
  'http://localhost:8000/events/event_id' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer your_token' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "event_name",
  "date": "event_date_in_iso8061_format",
  "location": {
    "latitude": double_lat,
    "longitude": double_long,
    "address": "optional_address"
  },
  "transition_from_previous": "optional_string",
  "trip_id": trip_id
}'
```

#### **Delete an Event**: `DELETE /events/{eventId}` - Delete a specific event.

Curl Example

```sh
curl -X 'DELETE' \
  'http://localhost:8000/events/event_id' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer your_token'
```

---

### Media Management

#### **Upload a Media**: `POST /media` - Adds a new media.

Curl Example

```sh
curl -X 'POST' \
  'http://localhost:8000/media' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer your_token' \
  -H 'Content-Type: application/json' \
  -d '{
  "caption": "optional_image_caption",
  "base64_data": "image_data_base64_encoded_string",
  "event_id": event_id
}'
```

#### **Delete a Media**: `DELETE /media/{mediaId}` - Delete a specific media.

Curl Example

```sh
curl -X 'DELETE' \
  'http://localhost:8000/media/media_id' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer your_token'
```
