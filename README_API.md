# APIs

## Authorization

for simplicity of the test, I use "Authorization" header key and "user guid" as the header value for the authentication process. This can be adjusted later on, we can use JWT for the auth token.
- header_key: Authorization
- header_value: {user_guid}

# APIs description

### Clock In - Start sleeping
- Path: POST /sleep/start
- Description: Used for recording the time when user start sleeping. It will add a record to user_sleep_logs table.
- Validation: User cannot clock in more than one time except they have to clock out first.
- Body Params: none

### Clock Out - Finish sleeping (wake up)
- Path: POST /sleep/finish
- Description: Used for clock out. After the user call the /sleep/start API they have to call the /sleep/finish API.
- Validation: User cannot clock out if they haven't clock in yet
- Body Params: none

### Get my sleep logs data
- Path: GET /sleep_logs/me
- Description: It will return my user sleep logs ordered by creation time
- Query Params: limit, page, order(id desc, id asc)

### Get friends sleep logs data
- Path: GET /sleep_logs/friends
- Description: It will return my friends sleep logs ordered by sleep duration
- Query Params: limit, page, min_sleep_date, order(duration desc, duration asc)

### Follow friend
- Path: POST /user/{user_guid}/follow
- Description: It will follow the given user guid
- Body Params: none

### Unfollow friend
- Path: POST /user/{user_guid}/unfollow
- Description: It will unfollow the given user guid
- Body Params: none

# Sample CURLs

```
POST /sleep/start
curl --location --request POST 'http://localhost:3000/sleep/start' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'

POST /sleep/finish
curl --location --request POST 'http://localhost:3000/sleep/start' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'

GET /sleep_logs/me
curl --location 'http://localhost:3000/sleep_logs/me?limit=20&page=1&order=id%20desc' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'

GET /sleep_logs/friends
curl --location 'http://localhost:3000/sleep_logs/friends?limit=20&page=1&min_sleep_date=&order=null' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'

POST /user/{user_guid}/follow
curl --location --request POST 'http://localhost:3000/user/0b5b8bb9-d38f-4771-9c86-fbff54d901d5/follow' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'

POST /user/{user_guid}/unfollow
curl --location --request POST 'http://localhost:3000/user/0b5b8bb9-d38f-4771-9c86-fbff54d901d5/unfollow' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6'
```
