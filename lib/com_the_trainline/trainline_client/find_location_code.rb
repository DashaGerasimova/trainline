# frozen_string_literal: true

require "httparty"

module ComTheTrainline
  module TrainlineClient
    class FindLocationCode
      URL = "https://www.thetrainline.com/api/locations-search/v2/search"
      LOCALE = "en-es"

      class << self
        def call(location)
          response = HTTParty.get(
            URL,
            query: {
              locale: LOCALE,
              searchTerm: location
            }
          )

          raise Error, "unable to fetch location codes" unless response.success?

          response.parsed_response.dig("searchLocations", 0, "code")
        end
      end
    end
  end
end
