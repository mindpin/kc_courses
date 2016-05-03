module KcCourses
  module Concerns
    module WareReadingMethod
      extend ActiveSupport::Concern

      included do
        has_many :ware_readings, class_name: 'KcCourses::WareReading'
        has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta', order: :created_at.asc
      end

      # 设置 user 已经完成了 ware 百分之 read_percent 的内容
      def set_read_percent_by_user(user, read_percent)
        return true if read_percent_of_user(user) >= (read_percent).to_f
        ware_reading = self.ware_readings.where(:creator_id => user.id.to_s).first
        if ware_reading.blank?
          self.ware_readings.create(:creator => user, :read_percent => read_percent)
        else
          ware_reading.update(:read_percent => read_percent)
        end
      end

      # user 已经学习了 ware 多少百分比的内容，返回值是代表百分比的数字
      def read_percent_of_user(user)
        return 0 if user == nil
        ware_readings.where(:creator_id => user.id.to_s).first.try(:read_percent) || 0
      end

      # user 是否已经完成整个 ware 的学习（read_percent 是 100 时，表示完成学习）
      def has_read_by_user?(user)
        read_percent_of_user(user) == 100
      end

      # user 截止到 time 当天（包括当天）已经学习了多少百分比的内容
      def read_percent_of_user_before_day(user, time)
        delta = ware_reading_deltas.where(
          :creator_id => user.id.to_s,
          :time.lte   => time.in_time_zone.end_of_day,
        ).last

        return 0 if delta.blank?
        delta.read_percent
      end

      # user 在 time 当天学习了多少百分比的内容
      # FIXME  这块应该有BUG，非当天区间
      def read_percent_change_of_user(user, time)
        delta = ware_reading_deltas.where(
          :creator_id => user.id.to_s,
          :time       => time.in_time_zone.beginning_of_day,
        ).first

        return 0 if delta.blank?
        delta.read_percent_change
      end


    end
  end
end
