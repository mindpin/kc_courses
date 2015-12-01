module KcCourses
  module Concerns
    module Base
      extend ActiveSupport::Concern

      included do
        scope :recent, -> {desc(:id)}
      end
    end
  end
end
