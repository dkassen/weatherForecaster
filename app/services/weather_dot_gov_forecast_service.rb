# This service is very specifically named because it deals only with the data coming from
# api.weather.gov; I had aspirations of this being an extensible class where the @api_client
# and @presenter_klass could be set to things that correspond to different data sources and
# means of displaying that data in a specific format. I eventually landed on displaying
# the name of the time frame and the detailed forecast from api.weather.gov because it
# returned a lot of easily consumable, readable, data about the weather, and it was easy.
class WeatherDotGovForecastService
  def self.get_forecast_for_zip_code(zip_code)
    location = LocationService.find_by_zip_code(zip_code)
    forecast_data = WeatherDotGovApiClient.get_forecast_for_coordinates(location.latitude, location.longitude)
    WeatherDotGovForecastPresenter.new(forecast_data).present
  end
end