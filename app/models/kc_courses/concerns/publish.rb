module KcCourses
  module Concerns
    module Publish
      extend ActiveSupport::Concern

      included do
        field :published, :type => Boolean, default: false

      end

      def publish!
        update_attribute :published, true
      end

      def unpublish!
        update_attribute :published, false
      end

      module ClassMethods
      end
    end
  end
end

