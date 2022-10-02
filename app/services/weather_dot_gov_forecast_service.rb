class WeatherDotGovForecastService
  def self.get_forecast_for_zip_code(zip_code)
    location = LocationService.find_by_zip_code(zip_code)
    forecast_data = WeatherDotGovApiClient.get_forecast_for_coordinates(location.latitude, location.longitude)
    WeatherDotGovForecastPresenter.new(forecast_data).present
  end
end