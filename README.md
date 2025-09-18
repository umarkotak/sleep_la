# Sleep La

Your sleep tracker

## Installation

```
bundle config path 'vendor/bundle' --local

bundle install

cp .sample.env .env

// update the .env file according to your environment

rails db:create

rails db:migrate
```

## Code Structure

-- controllers -> to receive HTTP request
|
---- services -> core business logic
|
------- models

This allows reusability of service

## Tables

users
-- created_at: timestamp
-- updated_at: timestamp
-- id: int
-- guid: string uuid      // unique
-- name: string
notes: I think user.guid is needed for public identifier. As using user.id will be a security concern such as allowing abuse of the system by simply iterating the ids.

user_sleep_logs
-- created_at: timestamp
-- updated_at: timestamp
-- id: int
-- user_id: int
-- sleep_date: date       // btree index
-- sleep_at: timestamp
-- wake_at: timestamp
-- duration_second: int
notes: added index on sleep_date for low cardinality column to avoid high index if we use sleep_at column

user_follows
-- -- created_at: timestamp
-- updated_at: timestamp
-- id: int
-- from_user_id: int         // unique
-- to_user_id: int           // unique

## APIs

Authorization: for simplicity, I use "Authorization" header key and the value is the "user guid". This can be adjusted later on if not acceptable
header_key: Authorization
header_value: {user_guid}

POST /sleep/start
- this api will record user sleep log, user cannot call /sleep api if the latest sleep log wake_at data is null
- body params: none

POST /sleep/finish
- this api will get the latest sleep log and update the wake_at data
- body params: none

GET /sleep_logs/me
- return user sleep log order by id desc (this should be the same with order by created_at desc)
- query params: limit, page

GET /sleep_logs/friends
- return the sleep log of all friend the current user follows

POST /user/{user_guid}/follow
- this api will insert to user_follows_table

POST /user/{user_guid}/unfollow
- this api will delete from user_follows_table
