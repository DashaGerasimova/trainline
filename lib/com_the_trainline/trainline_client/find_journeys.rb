# frozen_string_literal: true

require "httparty"

module ComTheTrainline
  module TrainlineClient
    class FindJourneys
      URL = "https://www.thetrainline.com/api/journey-search/"

      class << self
        def call(from:, to:, departure_at:)
          response = HTTParty.post(
            URL,
            body: {
              transitDefinitions: {
                origin: from,
                destination: to,
                journeyDate: {
                  type: "departAfter",
                  time: departure_at
                }
              }
            }
          )

          raise Error, "unable to fetch journeys" unless response.success?

          response.parsed_response
        end
      end
    end
  end
end
