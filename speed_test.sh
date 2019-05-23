#!/bin/bash
AUTH=eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNSwiZXhwIjoxNTU4NzM0MDM0fQ.LhUOu2hQyNKpastWjCdI4tihHxkzU2po5tBME7Oe7oQ

# WARM UP - 4 test hits
echo 'Warming up...'

curl -s -H "Authorization: ${AUTH}" http://localhost:3000/test > /dev/null
curl -s -H "Authorization: ${AUTH}" http://localhost:3000/test > /dev/null
curl -s -H "Authorization: ${AUTH}" http://localhost:3000/test > /dev/null
curl -s -H "Authorization: ${AUTH}" http://localhost:3000/test > /dev/null
curl -s -H "Authorization: ${AUTH}" http://localhost:3000/test > /dev/null

curl -s -H "Content-Type: application/json" -H "Authorization: ${AUTH}" -s -X GET -d @small.json http://localhost:3000/analyze_no_threads > /dev/null
curl -s -H "Content-Type: application/json" -H "Authorization: ${AUTH}" -X GET  -d @small.json http://localhost:3000/analyze  > /dev/null

echo 'Starting Benchmark test:'

# Payload of 300, 4 times

for i in {1..4}
do
  curl -w "$i: Response: %{http_code}, Total time: %{time_total}\n" --output /dev/null -H "Content-Type: application/json" -H "Authorization: ${AUTH}" -s -X GET -d @payload.json http://localhost:3000/analyze_no_threads
done

echo 'Starting thread test:'

# Payload of 300, 4 times

for i in {1..4}
do
  curl -w "$i: Response: %{http_code}, Total time: %{time_total}\n" -s --output /dev/null -H "Content-Type: application/json" -H "Authorization: ${AUTH}" -X GET  -d @payload.json http://localhost:3000/analyze
done
