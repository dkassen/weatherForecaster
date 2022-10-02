Rails.application.routes.draw do
  get '/weather_forecast/:zip_code' => 'weather_forecast#show'
end
