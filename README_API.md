# APIs

## Authorization

user need to get the auth token first by calling POST /goodnight/api/v1/auth/login with user guid.
- header_key: Authorization
- header_value: Bearer {auth_token}

# APIs description

### Login
- Path: POST /goodnight/api/v1/auth/login
- Description: This API is used to get the authentication token.
- Body Params: { "user_guid": "" }
- Notes: For simplicity, i only use user guid for auth. ideally this should be something like email + password. since the docs didn't specify any auth mechanism, i went with the simplest one

### Clock In - Start sleeping
- Path: POST /goodnight/api/v1/sleep/start
- Description: Used for recording the time when user start sleeping. It will add a record to user_sleep_logs table.
- Validation: User cannot clock in more than one time except they have to clock out first.
- Body Params: none

### Clock Out - Finish sleeping (wake up)
- Path: POST /goodnight/api/v1/sleep/finish
- Description: Used for clock out. After the user call the /sleep/start API they have to call the /sleep/finish API.
- Validation: User cannot clock out if they haven't clock in yet
- Body Params: none

### Get my sleep logs data
- Path: GET /goodnight/api/v1/sleep_logs/me
- Description: It will return my user sleep logs ordered by creation time
- Query Params: limit, page, order(id desc, id asc)

### Get friends sleep logs data
- Path: GET /goodnight/api/v1/sleep_logs/friends
- Description: It will return my friends sleep logs ordered by sleep duration
- Query Params: limit, page, min_sleep_date, order(duration desc, duration asc)

### Follow friend
- Path: POST /goodnight/api/v1/user/{user_guid}/follow
- Description: It will follow the given user guid
- Body Params: none

### Unfollow friend
- Path: POST /goodnight/api/v1/user/{user_guid}/unfollow
- Description: It will unfollow the given user guid
- Body Params: none

### Helath check
- Path: GET /goodnight/api/health
- Description: Quickly check if the app is online

# Sample CURLs

```
POST /goodnight/api/v1/auth/login
curl --location 'http://localhost:3000/goodnight/api/v1/auth/login' \
--header 'Authorization: e9e06402-757a-4649-9f5c-2961185738a6' \
--header 'Content-Type: application/json' \
--data '{
    "user_guid": "e9e06402-757a-4649-9f5c-2961185738a6"
}'

POST /goodnight/api/v1/sleep/start
curl --location --request POST 'http://localhost:3000/goodnight/api/v1/sleep/start' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'

POST /goodnight/api/v1/sleep/finish
curl --location --request POST 'http://localhost:3000/goodnight/api/v1/sleep/finish' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'

GET /goodnight/api/v1/sleep_logs/me
curl --location 'http://localhost:3000/goodnight/api/v1/sleep_logs/me?limit=20&page=1&order=id%20desc' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'

GET /goodnight/api/v1/sleep_logs/friends
curl --location 'http://localhost:3000/goodnight/api/v1/sleep_logs/friends?limit=20&page=1&min_sleep_date=&order=null' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'

POST /goodnight/api/v1/user/{user_guid}/follow
curl --location --request POST 'http://localhost:3000/goodnight/api/v1/user/0b5b8bb9-d38f-4771-9c86-fbff54d901d5/follow' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'

POST /goodnight/api/v1/user/{user_guid}/unfollow
curl --location --request POST 'http://localhost:3000/goodnight/api/v1/user/0b5b8bb9-d38f-4771-9c86-fbff54d901d5/unfollow' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnb29kLW5pZ2h0LXNsZWVwLWxhLWFwcCIsInN1YiI6ImU5ZTA2NDAyLTc1N2EtNDY0OS05ZjVjLTI5NjExODU3MzhhNiIsImlhdCI6MTc1ODMzNjQwMCwianRpIjoiNDAzYTExNTQtMTI3MS00NjQzLTg0ZTYtYTljZmMzZTEwYmU5In0.fSKZOWSeZ-R3myhqC_cqUpF7uiyYpVogRj4X7W4CKww'
```
