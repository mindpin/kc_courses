module KcCourses
  module Concerns
    module MovePosition
      extend ActiveSupport::Concern

      included do
        field :position, :type => Integer
        default_scope ->{ order(position: :asc) }

        before_create :set_position
      end

      def set_position
        #self.position = self.id
        #self.save
        self.position = Time.now.to_i
      end

      def prev
        self.class.by_course(course).where(:position.lt => self.position).last
      end

      def next
        self.class.by_course(course).where(:position.gt => self.position).first
      end

      def move_down
        next_record = self.next
        return nil if next_record.nil?

        pos = self.position
        self.position = next_record.position
        self.save!

        next_record.position = pos
        next_record.save!

        self
      end

      def move_up
        prev_record = self.prev
        return nil if prev_record.nil?

        pos = self.position
        self.position = prev_record.position
        self.save!

        prev_record.position = pos
        prev_record.save!

        self
      end

      module ClassMethods
      end
    end
  end
end
