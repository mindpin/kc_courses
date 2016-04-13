module KcCourses
  module Concerns
    module DiscussSetting
      extend ActiveSupport::Concern

      included do
        field :enabled, type: Boolean, default: true
        field :all_could_view, type: Boolean, default: true
        field :all_could_post, type: Boolean, default: true
      end
    end
  end
end

