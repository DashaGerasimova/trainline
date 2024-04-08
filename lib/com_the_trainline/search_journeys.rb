# frozen_string_literal: true

require_relative "trainline_client/find_location_code"
require_relative "trainline_client/find_journeys"

module ComTheTrainline
  # Get the list of journeys from an API (or from local storage if data is unavailable)
  class SearchJourneys
    class << self
      def call(from:, to:, departure_at:)
        origin_code = TrainlineClient::FindLocationCode.call(from)
        destination_code = TrainlineClient::FindLocationCode.call(to)

        TrainlineClient::FindJourneys.call(
          from: origin_code, to: destination_code, departure_at: departure_at.iso8601
        )
      rescue Error => e
        # Logging error
        puts "Trainline API Error: #{e}"
        puts "Switching to saved local data"

        # Fetch local saved data
        JSON.parse(
          File.read("lib/com_the_trainline/local_data/sample.json")
        )
      end
    end
  end
end
