# Good Night - Sleep La

Your sleep tracker

### Api notes can be read on README_API.md

## Pre Requisites

```
// postgres database
// for mac user you can use this command to install postgres
brew install postgresql

// rbenv for ruby versioning
// you can follow this instruction to install rbenv
https://github.com/rbenv/rbenv?tab=readme-ov-file#installation

// ruby 3.4.4
// you can use rbenv to install ruby 3.4.4
rbenv install 3.4.4

// enable ruby 3.4.4
rbenv local 3.4.4
```

## Installation

```
bundle config path 'vendor/bundle' --local

bundle install

cp .sample.env .env

// update the .env file according to your environment

rails db:create

rails db:migrate

rails db:seed
```

## Run Application
```
rails s
```

## Run Test
```
bundle exec rspec
```

## See Code Coverage
```
// this file is generated after running rspec
open coverage/index.html
```

## Code Structure

```
-- controllers -> to receive HTTP request
|
---- services  -> core business logic
|
------- models -> interacting with database

This allows reusability of service
```

## Tables

```
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
notes: added index on sleep_date for low cardinality column to avoid high index if we use sleep_at column. this is needed if the data is getting bigger and we want to fetch data based on time

user_follows
-- created_at: timestamp
-- updated_at: timestamp
-- id: int
-- from_user_id: int
-- to_user_id: int
notes: (from_user_id, to_user_id) unique
```

## Current strategies to handle high data volumes and concurrent requests

```
1. When sleep clock in process there is sleep_date column that is btree indexed. This column have low cardinality (less unique values) so the indexing is less big compared to use sleep_at as index which is an exact time.

2. When user get their friends sleep log records for the last week, I filter the query based on the sleep_date index so that the records look up is fast.
```

## Future Improvement For Handling High Load

Here are few scaling up scenarios that I propose:

```
1. When a high traffic of users submitting clock in (start sleep) at the same time, eg: at 19:00 o clock.
1.1 We can horizontally scale the Good Night App (eg: 2-3 instance) and put a load balancer on top of it. This allows traffic to be distributed among the instances hence write process will be faster.
1.2 If we don't care about the realtime result, since for example after the user clock in they will immediately sleep. We can implement queuing for submitting the clock in data. This is to avoid high concurent write to the database.

2. When a high traffic of users checking their friends sleep logs, eg: at 07:00 o clock.
2.1 We can make the database to be master-slave relationship. This allows read operation to be focused on the slave replica so that it won't takes the resource of the master.
```
