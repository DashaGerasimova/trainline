# frozen_string_literal: true

require 'date'
require_relative "com_the_trainline/version"
require_relative "com_the_trainline/search_journeys"
require_relative "com_the_trainline/parse_journeys"

module ComTheTrainline
  class Error < StandardError; end

  def self.find(from:, to:, departure_at: DateTime.now)
    journeys = SearchJourneys.call(from:, to:, departure_at:)

    ParseJourneys.call(journeys)
  end
end
