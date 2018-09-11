# Bowling API

Rules of scoring for ten-pin bowling:

https://en.wikipedia.org/wiki/Ten-pin_bowling

http://slocums.homestead.com/gamescore.html

To run the application:

0. Clone this repo locally

    `$ git clone git@github.com:svetlik/bowling_api.git`
1. Run the Rails server:

    `$ rails s`

2. Call the JSON API. You can use Postman, in which case, there is a collection file `Bowling_API.postman_collection.json` added to the project, that you can import, and execute the calls from.

Alternatively, there is a Demo currently live at [Heroku](https://polar-wave-42779.herokuapp.com) where you can address calls to the API directly.

# API Documentation

Endpoints:

- POST `/api/games`

Creates a new game, and returns its ID for easier initial reference.

```
{
  "id": 2354
}
```

Response: `HTTP 201 Created`

- GET `/api/games/:id`

Show details about a game by its `id`. Will return `id`, `score`, `frames`, `current_frame`, `last_roll_score`:

```
{
    "id": 2205,
    "score": 115,
    "frames": [
        [
            "3",
            "3",
            null
        ],
        [
            "10",
            "4",
            "5"
        ],
        [
            "4",
            "5",
            null
        ],
        [
            "6",
            "3",
            null
        ],
        [
            "10",
            "10",
            "10"
        ],
        [
            "10",
            "10",
            "4"
        ],
        [
            "10",
            "4",
            null
        ],
        [
            "4",
            null,
            null
        ],
        [
            null,
            null,
            null
        ],
        [
            null,
            null,
            null
        ]
    ],
    "last_frame": 7,
    "last_roll_score": 4
}
```

response: `HTTP OK 200`

- PUT/PATCH `/api/games/:id?roll_score=5`

Adds score to the frame, and updates the game score.

response: `HTTP 204 No Content`

In case of erratic input, the following errors should be displayed:

- in case of input different than an integer:

```
"Throw score cannot be a non-integer symbol"
```

- in case of second throw for a frame, if given input adds up to more than 10, a message about the maximum number that should the input be equal to:

```
"Pin number cannot exceed 2."
```

- in case an integer bigger than 10 is given:

```
"Throw score cannot be more than 10."
```

- in case an attempt to update the game has been made after the last frame:
```
"Game has already ended."
```
