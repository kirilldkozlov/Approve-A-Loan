# Approve-A-Loan

This project uses the 1993 German Credit Dataset to predict whether a credit applicant will be a suitable customer. The application uses a decision tree classifier to determine an outcome. The conceptual usage for this program would be for a small business, such as a used car dealership, to quickly process an application and determine if they should approve a loan for a customer.

This application is inspired and based on the following course: https://onlinecourses.science.psu.edu/stat857/node/215

The classifier used achieves a ~77% accuracy which is close to the expected accuracy determined above. The accuracy would increase dramatically with a larger dataset, currently it only processes 1000 records.

## Highlights
Asynchronous Sidekiq background processing, Built a REST API with JWT token authentication and MySQL search functions, Unit testing, Comprehensive validations and error catching, Web scraper to fetch currency rates, Encryption of data and parameters, MVC design pattern, OOD throughout the app, Javascript form enhancements, Bootstrap design

## Screenshots
Please see Issue #19 'Screenshots'

## Running the application

1. Start Redis
- On local machine, first `cd ~/redis-stable/src` then run `./redis-server`
2. Run `bundle exec sidekiq`
3. Run `rails server`
4. Go to `http://localhost:3000`

## API

Approve-A-Loan has an API to provide easier access to relevant logs for authenticated users. A scenario which would require such a feature could be for a business who wants to integrate their existing credit processsing workflow with Approve-A-Loan. The API uses the JWT Web Token protocol which is appropriate for a request per request API, as opposed to a session based API.

The API has 3 end points. `test` which allows clients to test their authentication, `exact_log` which will take a name string as a param and return the last record matching that name and `logs` which will take a name string as a param and return any record which matches any of these conditions:
- has the name
- has the first name
- has the last name
- has the first 3 letters of the first name
- has the first 3 letters of the last name

This end point is for searches and look ups of logs.

## Using the API

1. Run `rails server`
2. Insure you have registered an `ApiUser`
3. Authenticate: `curl -H "Content-Type: application/json" -X POST -d '{"email":"email","password":"password"}' http://localhost:3000/authenticate`
4. Run a query: 
- `curl -H "Authorization: INSERT_TOKEN_HERE" http://localhost:3000/test`
- `curl -H "Authorization: INSERT_TOKEN_HERE" http://localhost:3000/logs/"Test%20Guy"`

## Application facts
- Test coverage `> 92%`
