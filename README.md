# README

Hellow and welcome to the weather forecast service! This is a simple app that takes in a zip code and returns the weather forecast for the coming week

* How To Use This App
Run the server using
```bundle exec rails server```
(or `rails s` if you're into the short version)

The server will run on port 3000, which you can change using the -p option:
```bundle exec rails s -p 9001```

In another terminal:
```curl localhost:<port_number>/weather_forecast/<zip_code>```

* Ruby version
3.1.2

* System dependencies
api.weather.gov needs to be up (usually is)

* How to run the test suite
```bundle exec rspec```

* How to run the server

* Attributions
Zip-code data located in lib/data comes from Stanford University. https://redivis.com/datasets/d5sz-fq0mbm2ty
Weather data provided by api.weather.gov
