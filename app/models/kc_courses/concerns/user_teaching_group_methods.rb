module KcCourses
  module Concerns
    module UserTeachingGroupMethods
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :authorized_teaching_groups, inverse_of: :authorized_members, class_name: 'TeachingGroup'
      end
    end
  end
end
