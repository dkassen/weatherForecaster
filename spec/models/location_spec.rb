RSpec.describe Location do
  let(:data) do
    {
      "geopoint" => "52.227555,-174.19628",
      "Daylight_savings_time_flag" => 1,
      "Timezone" => -10,
      "Longitude" => -174.19628,
      "Latitude" => 52.227555,
      "State" => "AK",
      "City" => "Atka",
      "Zip" => 99547,
    }
  end

  subject do
    Location.new(
      latitude: data['Latitude'],
      longitude: data['Longitude'],
      city: data['City'],
      state: data['State'],
      zip_code: data['Zip']
    )
  end

  its(:latitude) { is_expected.to eq data['Latitude'] }
  its(:longitude) { is_expected.to eq data['Longitude'] }
  its(:city) { is_expected.to eq data['City'] }
  its(:state) { is_expected.to eq data['State'] }
  its(:zip_code) { is_expected.to eq data['Zip'] }
end