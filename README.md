# README

Hello and welcome to the weather forecast service! This is a simple app that takes in a zip code via URL aprams and returns the weather forecast for the coming week. It uses the US government's weather api at `api.weather.gov` as its data source (which they have set up so it takes a two requests to get a forecast, so give it a second). 

## How To Use This App
Run the server using
```bundle exec rails server```
(or `rails s` if you're into the short version)

The server will run on port 3000, which you can change using the -p option:
```bundle exec rails s -p 9001```

In another terminal:
```curl localhost:<port_number>/weather_forecast/<zip_code>```

## How to run the test suite
```bundle exec rspec```

## Attributions
Zip-code data located in lib/data comes from Stanford University. https://redivis.com/datasets/d5sz-fq0mbm2ty
Weather data provided by api.weather.gov
