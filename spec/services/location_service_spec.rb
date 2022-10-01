RSpec.describe LocationService do
  describe '.find_by_zip_code' do
    subject { described_class.find_by_zip_code(zip_code) }

    context 'when the supplied with a valid zip code' do
      let(:zip_code) { 90210 }

      it { is_expected.to be_a Location }
    end

    context 'when the supplied zip code is a string' do
      let(:zip_code) { '90210' }

      it { is_expected.to be_a Location }
    end

    context 'when the supplied zip code is not valid' do
      let(:zip_code) { 'right behind you 👀' }

      it 'raises an error' do
        expect { subject }.to raise_error LocationService::NotFoundError do |error|
          expect(error.message).to eq 'location not found for zip code "right behind you 👀"'
        end
      end
    end
  end
end
