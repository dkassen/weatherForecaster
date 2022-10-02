require 'csv'

class LocationService
  class NotFoundError < StandardError; end
  # initialize the class with data a hash of zip-code to location
  # info that will not change (soon, at least, and not without some big notices)
  @@locations_by_zip_code = begin
    path = Rails.root.join('lib/data/US_ZIP_codes_to_longitude_and_latitude.csv')
    rows = ::CSV.read path, headers: true
    locations = rows.map do |row|
      Location.new(
        latitude: row['Latitude'].to_f,
        longitude: row['Longitude'].to_f,
        state: row['State'],
        city: row['City'],
        zip_code: row['Zip'].to_i,
      )
    end
    locations.index_by(&:zip_code)
  end

  def self.find_by_zip_code(zip_code)
    location = @@locations_by_zip_code[zip_code.to_i]

    return location if location.present?

    raise NotFoundError.new "location not found for zip code #{zip_code.inspect}"
  end
end