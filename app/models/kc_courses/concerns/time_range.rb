module KcCourses
  module Concerns
    module TimeRange
      extend ActiveSupport::Concern

      included do
        field :started_at, type: Time
        field :ended_at, type: Time
      end

      def started?
        started_at.nil? || Time.now >= started_at
      end

      def ended?
        return false if ended_at.nil?
        Time.now >= ended_at
      end

      def running?
        started? and !ended?
      end

    end
  end
end
