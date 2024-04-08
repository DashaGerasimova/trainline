require "com_the_trainline/trainline_client/find_journeys"
require "com_the_trainline/trainline_client/find_location_code"


RSpec.describe ComTheTrainline::SearchJourneys do
  describe '.call' do
    subject { described_class.call(from: origin, to: destination, departure_at: departure_at) }

    context 'when Trainline API call is successful' do
      let(:origin) { 'London' }
      let(:destination) { 'Manchester' }
      let(:departure_at) { Time.now }

      it 'calls TrainlineClient::FindLocationCode and TrainlineClient::FindJourneys' do
        expect(ComTheTrainline::TrainlineClient::FindLocationCode).to receive(:call).with(origin).and_return('urn:trainline:generic:loc:182gb')
        expect(ComTheTrainline::TrainlineClient::FindLocationCode).to receive(:call).with(destination).and_return('urn:trainline:generic:loc:115gb')
        expect(ComTheTrainline::TrainlineClient::FindJourneys).to receive(:call).with(from: 'urn:trainline:generic:loc:182gb', to: 'urn:trainline:generic:loc:115gb', departure_at: departure_at.iso8601)

        subject
      end
    end

    context 'when Trainline API call raises an error' do
      let(:origin) { 'InvalidLocation' }
      let(:destination) { 'Manchester' }
      let(:departure_at) { Time.now }

      it 'rescues the error and loads local data' do
        allow(ComTheTrainline::TrainlineClient::FindLocationCode).to receive(:call).and_raise(ComTheTrainline::Error)
        expect(File).to receive(:read).with("lib/com_the_trainline/local_data/sample2.json").and_return('{}')

        subject
      end
    end
  end
end
