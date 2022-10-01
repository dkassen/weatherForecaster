class Location
  attr_reader :latitude, :longitude, :city, :state, :zip_code

  def initialize(latitude:, longitude:, city:, state:, zip_code:)
    @latitude = latitude
    @longitude = longitude
    @city = city
    @state = state
    @zip_code = zip_code
  end
end