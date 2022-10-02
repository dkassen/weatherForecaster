class WeatherDotGovForecastPresenter
  def initialize(periods)
    @periods = periods
  end

  def present
    # api.weather.gov has an easy interface.
    # name is something like "Sunday night"
    # detailedForecast is "Mostly cloudy, with a low of 66. Southwest winds of 5 to 10mph"
    @periods.map { "#{_1['name']}: #{_1['detailedForecast']}" }.join "\n"
  end
end
