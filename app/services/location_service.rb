require 'csv'

class LocationService
  def self.load_data!
    return true if defined? @@locations_by_zip_code
    csv_path = Rails.root.join('lib/data/US_ZIP_codes_to_longitude_and_latitude.csv')
    rows = ::CSV.read csv_path
    locations = rows.map do |row|
      Location.new(
        latitude: row['Latitude'],
        longitude: row['Longitude'],
        state: row['State'],
        city: row['City'],
        zip_code: row['Zip'],
      )
    end
    @@locations_by_zip_code = locations.index_by(&:zip_code)
    true
  end
end