RSpec.describe ComTheTrainline::ParseJourneys do
  describe '#call' do
    subject { described_class.call(response) }

    let(:response) do
      JSON.parse(
        File.read("lib/com_the_trainline/local_data/sample2.json")
      )
    end

    it 'returns a hash with parsed journey information' do
      elem = subject[0]
      expect(elem.keys).to contain_exactly(
                                :departure_station, :departure_at, :arrival_station, :arrival_at,
                                :duration_in_minutes, :changeovers, :service_agencies, :products, :fares
                              )

      expect(elem[:departure_station]).to be_a(String)
      expect(elem[:departure_at]).to be_a(Time)
      expect(elem[:arrival_station]).to be_a(String)
      expect(elem[:arrival_at]).to be_a(Time)
      expect(elem[:duration_in_minutes]).to be_a(Integer)
      expect(elem[:changeovers]).to be_a(Integer)
      expect(elem[:service_agencies]).to be_an(Array)
      expect(elem[:products]).to be_an(Array)
      expect(elem[:fares]).to be_an(Array)
    end
  end
end
