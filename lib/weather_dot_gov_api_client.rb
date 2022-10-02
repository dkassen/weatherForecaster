class WeatherDotGovApiClient
  class ApiError < StandardError; end

  class << self 
    def get_forecast_for_coordinates(latitude, longitude)
      # api.weather.gov returns errors if we send requests with more than 4 decimal places
      rounded_latitude = latitude.round(4)
      rounded_longitude = longitude.round(4)

      # weather.gov first makes you request grid points for the location
      location_properties = get_location_properties(rounded_latitude, rounded_longitude)
      # use the data bits to build the path to the corresponding forecast data
      path = build_forecast_url_path(location_properties)
      # the second api call
      get_forecast(path)
    rescue Faraday::Error => e
      raise ApiError.new <<~ERROR
          There was an error connecting to api.weather.gov: #{e.message}
        ERROR
    end

    private

    def get_location_properties(latitude, longitude)
      response = connection.get("/points/#{latitude},#{longitude}")

      unless response.success?
        raise ApiError.new <<~ERROR
          Something went wrong fetching forecast metadata from api.weather.gov:
          Latitude: #{latitude}
          Longitude: #{longitude}
          Status: #{response.status}
          Body: #{response.body}
        ERROR
      end

      JSON.parse(response.body)['properties']
    end

    def build_forecast_url_path(properties)
      grid_id = properties['gridId']
      grid_x = properties['gridX']
      grid_y = properties['gridY']

      "/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/forecast"
    end

    def get_forecast(path)
      response = connection.get(path)

      unless response.success?
        raise ApiError.new <<~ERROR
          Something went wrong fetching forecast data from api.weather.gov:
          Request Path: #{path}
          Status: #{response.status}
          Body: #{response.body}
        ERROR
      end

      JSON.parse(response.body)['properties']['periods']
    end

    def connection
      @connection ||= Faraday.new(
        url: 'https://api.weather.gov',
        headers: {'User-Agent' => 'WeatherForecaster daniel.s.kassen@gmail.com'}
      )
    end
  end
end