module ComTheTrainline
  # Parse the journeys data to our format
  class ParseJourneys

    def self.call(*)
      new(*).call
    end

    def initialize(response)
      @journeys = response.dig('data', 'journeySearch', 'journeys')

      # Stations
      @locations = response.dig('data', 'locations')

      # Contains list of alternatives for the journey
      @sections = response.dig('data', 'journeySearch', 'sections')

      # all possible price variants for the journey
      @alternatives = response.dig('data', 'journeySearch', 'alternatives')

      # Additional info for the price variant
      @fares = response.dig('data', 'journeySearch', 'fares')

      @transport_companies = response.dig('data', 'fareTypes')

      @transport_types = response.dig('data', 'transportModes')

      # Additional travel information (location transport etc)
      @legs = response.dig('data', 'journeySearch', 'legs')
    end

    def call
      @journeys.map do |journey_id, journey|
        parse_journey(journey)
      end
    end

    private

    def parse_journey(journey)
      journey_legs = journey['legs'].map { |leg| @legs[leg] }
      arrival_at = Time.parse(journey['arriveAt'])
      departure_at = Time.parse(journey['departAt'])
      # Departure station is the station in the first leg
      departure_station = @locations[journey_legs.first['departureLocation']]['name']
      # Arrival station is the station in the last leg
      arrival_station = @locations[journey_legs.last['arrivalLocation']]['name']
      service_agencies = []
      products = []
      duration_in_minutes = (arrival_at - departure_at).to_i / 60
      changeovers = journey_legs.count - 1

      journey_fares = journey['sections'].map do |section|
        @sections[section]["alternatives"].map do |alternative|
          alternative = @alternatives[alternative]
          fare = @fares[alternative['fares'].first]

          transport_info = fare.dig('fareLegs', 0, 'travelClass', 'code')
          service_agencies << transport_info.match(/urn:(\w+)/)[1]
          products << transport_info.match(/urn:\w+:(\w+)/)[1]

          {
            name: @transport_companies[fare['fareType']]['name'],
            price_in_cents: alternative.dig('fullPrice', 'amount'),
            currency: alternative.dig('fullPrice', 'currencyCode'),
            comfort_class: fare.dig('fareLegs', 0, 'travelClass', 'name')
          }
        end
      end

      {
        departure_station:, departure_at:,
        arrival_station:, arrival_at:,
        duration_in_minutes:, changeovers:,
        service_agencies: service_agencies.uniq, products: products.uniq,
        :fares => journey_fares.flatten,
      }

    end

  end
end
