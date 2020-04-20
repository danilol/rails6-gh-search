# README

Very simple app to search public repositories from github using Rails 6.

Authentication is not working properly, affecting searchs with big number of results, so it returns an error for reaching the request limits.

Suggested search:
 - usernames
 - byebug
 - bootsnap
 - factory_bot_rails
 - will_paginate
 - paper-trail

## Setup
`git clone `

`bundle`

`rails s`

## Tests
To run the controller tests:

`rspec`

## TODO list:
- [ ] Pagination
- [ ] Capybara tests
- [ ] Authentication is not working properly
- [ ] Remove secrets from controller
