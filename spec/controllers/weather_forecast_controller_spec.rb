require 'spec_helper'

RSpec.describe WeatherForecastController do
  let(:json) { JSON.parse(response.body) }

  context "when the supplied zip code format is valid" do
    let(:zip_code) { 95014 }

    context "when the underlying services return a valid forecast" do
      let(:forecast) { "Oh my LORT is it sunny out here." }

      before do
        allow(WeatherDotGovForecastService)
          .to receive(:get_forecast_for_zip_code)
          .with(zip_code.to_s)
          .and_return(forecast)
      end

      context "when the zip code is an integer" do
        it "returns a successful response" do
          get :show, params: { zip_code: zip_code }

          expect(response).to be_successful
          expect(json['forecast']).to eq forecast
        end
      end

      context "when the zip code is string" do
        let(:zip_code) { '95014' }

        it "returns a successful response" do
          get :show, params: { zip_code: zip_code }

          expect(response).to be_successful
          expect(json['forecast']).to eq forecast
        end
      end

      context "when the zip code parameters has the extra 4 digits on it" do
        let(:zip_code) { '95014' }
        let(:zip_code_4) { '95014-9001' }

        it "returns a successful response" do
          get :show, params: { zip_code: zip_code_4 }

          expect(response).to be_successful
          expect(json['forecast']).to eq forecast
        end
      end
    end

    context "when the zip code can't be found" do
      let(:zip_code) { '99999' }

      it "returns a 404" do
        get :show, params: { zip_code: zip_code }

        expect(response).to be_not_found
        expect(json['message']).to eq 'location not found for zip code "99999"'
      end
    end

    context "when there is an error with fetching data from the source" do
      before do
        allow(WeatherDotGovForecastService)
          .to receive(:get_forecast_for_zip_code)
          .and_raise WeatherDotGovApiClient::ApiError.new('Ruh roh Rhaggy')
      end

      it "returns a 500" do
        get :show, params: { zip_code: zip_code }

        expect(response).to be_server_error
        expect(json['message']).to include 'Please try again'
      end
    end
  end

  context "when the zip code is not valid" do
    let(:zip_code) { "like 7 or something" }

    it "returns a 400" do
      get :show, params: { zip_code: zip_code }

      expect(response).to be_bad_request
      expect(json['message']).to eq 'Invalid Zip Code: "like 7 or something"'
    end
  end
end