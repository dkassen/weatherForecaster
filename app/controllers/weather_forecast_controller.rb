class WeatherForecastController < ApplicationController
  def show
    forecast = Rails.cache.fetch(zip_code, expires_in: 30.minutes) do
      WeatherDotGovForecastService.get_forecast_for_zip_code(zip_code)
    end

    render json: { forecast: forecast }, status: 200
  end

  private

  rescue_from LocationService::NotFoundError do |e|
    render json: { message: e.message }, status: 404
  end

  rescue_from WeatherDotGovApiClient::ApiError do |e|
    # Bugsnag.notify(e.message) because those were more for debugging purposes
    render json: { message: "There was an issue fetching forecast information. Please try again." }, status: 500
  end


  def zip_code
    # we don't deal with XXXXX-XXXX zip codes here
    # string 'em, strip 'em, cut them down to the first 5 digits
    zip_code = params.require(:zip_code).to_s.strip[0..4]
    
    # make sure it's a number within the zip-code range
    unless (1..99999).include? zip_code.to_i
      raise ActionController::BadRequest.new("Invalid Zip Code: #{params['zip_code'].inspect}")
    end

    # in case someone thought it was funny to put in '501'
    # (00501 is the lowest-numbered zip code) pad some zeros
    if zip_code.length < 5
      num_padding_zeros  = 5 - zip_code.length
      zip_code = '0' * num_padding_zeros + zip_code
    end

    zip_code
  end
end