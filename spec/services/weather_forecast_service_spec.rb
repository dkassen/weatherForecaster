RSpec.describe WeatherDotGovForecastService do
  include WebMock::API

  before { WebMock.enable! }
  after { WebMock.disable! }

  describe '.get_forecast_for_zip_code' do
    subject { described_class.get_forecast_for_zip_code(zip_code) }

    context "when the zip code is not found" do
      let(:zip_code) { "Zippity Doo Da" }

      it "raises a location error" do
        expect { subject }.to raise_error LocationService::NotFoundError 
      end
    end

    context "when api.weather.gov raises an error" do
      let(:zip_code) { 95014 }

      before do
        # lat/long coordinates for 95014 are -122.04779,37.317909 (rounds to 37.3179, -122.0478)
        stub_request(:get, "https://api.weather.gov/points/37.3179,-122.0478")
          .to_return(status: 500, body: { message: "INTERNAL_SERVER_ERROR" }.to_json)
      end

      it "raises the error" do
        expect { subject }.to raise_error WeatherDotGovApiClient::ApiError
      end
    end

    context "when everything goes according to plan" do
      let(:zip_code) { 95014 }

      before do
        stub_request(:get, "https://api.weather.gov/points/37.3179,-122.0478")
          .to_return(
            status: 200,
            body: {
              properties: {
                gridId: "YOLO",
                gridX: 9001,
                gridY: 1337,
              }
            }.to_json
          )
        stub_request(:get, "https://api.weather.gov/gridpoints/YOLO/9001,1337/forecast")
          .to_return(
            status: 200,
            body: {
              properties: {
                periods: [
                  {
                    "name" => "This Afternoon",
                    "detailedForecast" => "Sunny, with a high near 76. Southwest wind 5 to 10 mph."
                  }
                ]
              }
            }.to_json
          )
      end

      it { is_expected.to eq 'This Afternoon: Sunny, with a high near 76. Southwest wind 5 to 10 mph.' }
    end
  end
end