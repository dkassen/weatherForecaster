RSpec.describe WeatherDotGovApiClient do
  include WebMock::API

  before { WebMock.enable! }
  after { WebMock.disable! }

  describe ".get_forecast_for_coordinates" do
    subject { described_class.get_forecast_for_coordinates(latitude, longitude) }
    
    let(:longitude) { -123.4567 }
    let(:latitude) { 56.7890 }
    let(:grid_id) { 'AAPL' }
    let(:grid_x) { 941 }
    let(:grid_y) { 765 }
    let(:metadata_response_status) { 200 }
    let(:metadata_response_body) do
      {
        properties: {
          gridId: grid_id,
          gridX: grid_x,
          gridY: grid_y,
        }
      }.to_json
    end
    let(:forecast_periods) do
      [
        {
            "number" => 1,
            "name" => "This Afternoon",
            "startTime" => "2022-10-01T14:00:00-07:00",
            "endTime" => "2022-10-01T18:00:00-07:00",
            "isDaytime" => true,
            "temperature" => 76,
            "temperatureUnit" => "F",
            "temperatureTrend" => nil,
            "windSpeed" => "5 to 10 mph",
            "windDirection" => "SW",
            "icon" => "https://api.weather.gov/icons/land/day/few?size=medium",
            "shortForecast" => "Sunny",
            "detailedForecast" => "Sunny, with a high near 76. Southwest wind 5 to 10 mph."
        },
        {
            "number" => 2,
            "name" => "Tonight",
            "startTime" => "2022-10-01T18:00:00-07:00",
            "endTime" => "2022-10-02T06:00:00-07:00",
            "isDaytime" => false,
            "temperature" => 59,
            "temperatureUnit" => "F",
            "temperatureTrend" => nil,
            "windSpeed" => "5 mph",
            "windDirection" => "WSW",
            "icon" => "https://api.weather.gov/icons/land/night/bkn?size=medium",
            "shortForecast" => "Mostly Cloudy",
            "detailedForecast" => "Mostly cloudy, with a low around 59. West southwest wind around 5 mph."
        }
      ]
    end
    let(:forecast_response_status) { 200 }
    let(:forecast_response_body) do
      {
        properties: {
          periods: forecast_periods
        }
      }.to_json
    end

    before do
      stub_request(:get, "https://api.weather.gov/points/#{latitude},#{longitude}")
        .to_return(status: metadata_response_status, body: metadata_response_body)
      stub_request(:get, "https://api.weather.gov/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/forecast")
        .to_return(status: forecast_response_status, body: forecast_response_body)
    end
    
    context "when the calls to api.weather.gov are successful" do
      it { is_expected.to eq forecast_periods }
    end


    context "when the metadata call fails" do
      let(:metadata_response_status) { 500 }
      let(:metadata_response_body) do
        {
          message: 'INTERNAL_SERVER_ERROR'
        }.to_json
      end

      it "raises an error with a descriptive message" do
        expect { subject }.to raise_error WeatherDotGovApiClient::ApiError do |e|
          expect(e.message).to include 'Something went wrong fetching forecast metadata from api.weather.gov'
          expect(e.message).to include '500'
          expect(e.message).to include 'INTERNAL_SERVER_ERROR'
        end
      end
    end

    context "when the forecast call fails", focus: true do
      let(:forecast_response_status) { 404 }
      let(:forecast_response_body) do
        {
          message: 'NOT_FOUND'
        }.to_json
      end

      it "raises an error with a descriptive message" do
        expect { subject }.to raise_error WeatherDotGovApiClient::ApiError do |e|
          expect(e.message).to include 'Something went wrong fetching forecast data from api.weather.gov'
          expect(e.message).to include '404'
          expect(e.message).to include 'NOT_FOUND'
        end
      end
    end
  end
end