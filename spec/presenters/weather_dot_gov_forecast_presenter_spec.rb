RSpec.describe WeatherDotGovForecastPresenter do
  describe '#present' do
    let(:forecast_data) do
      [
        {
          "name" => "Sunday",
          "detailedForecast" => "Partly cloudy, with a chance of hamburgers"
        },
        {
          "name" => "Frensday",
          "detailedForecast" => "Oh, we're doing brunch for SURE, buddy"
        }
      ]
    end

    subject { described_class.new(forecast_data).present }

    it { is_expected.to eq "Sunday: Partly cloudy, with a chance of hamburgers\nFrensday: Oh, we're doing brunch for SURE, buddy" }
  end
end
