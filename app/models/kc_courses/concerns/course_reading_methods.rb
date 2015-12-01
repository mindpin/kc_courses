module KcCourses
  module Concerns
    module CourseReadingMethods
      extend ActiveSupport::Concern

      included do
        has_many :ware_readings, class_name: 'KcCourses::WareReading'
        has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta'
      end

      # user 已经学习了 course 多少百分比的内容，返回值是代表百分比的数字
      def read_percent_of_user(user)
        return 0 if user == nil
        return 0 if chapters.count == 0
        read_percent_hash = {}
        chapters.each do |chapter|
          read_percent_hash[chapter] = []
        end

        ware_readings.where(:creator_id => user.id.to_s).map do |reading|
          read_percent_hash[reading.chapter] << reading.read_percent
        end

        read_percent_hash.map do |chapter, value|
          if chapter.wares.count == 0
            0
          else
            value.sum / chapter.wares.count
          end
        end.sum / chapters.count
      end

      # user 是否已经完成整个 course 的学习（read_percent 是 100 时，表示完成学习）
      def has_read_by_user?(user)
        read_percent_of_user(user) == 100
      end

      # user 截止到 time 当天（包括当天）已经学习了多少百分比的内容
      def read_percent_of_user_before_day(user, time)
        read_percents = chapters.map do |chapter|
          chapter.read_percent_of_user_before_day(user, time)
        end

        return 0 if read_percents.count == 0
        read_percents.sum / read_percents.count
      end

      # user 在 time 当天学习了多少百分比的内容
      def read_percent_change_of_user(user, time)
        read_percents = chapters.map do |chapter|
          chapter.read_percent_change_of_user(user, time)
        end

        return 0 if read_percents.count == 0
        read_percents.sum / read_percents.count
      end

      # user 在当前课程正在学习的课件
      def studing_ware_of_user(user)
        ware_reading_count = 0 
        ware_count = 0 
        chapters.each do |chapter|
          ware_count = ware_count + chapter.wares.count
          chapter.wares.each do |ware|
            ware_reading_count = ware_reading_count + ware.ware_readings.count
          end 
        end
        # 没有课件
        return nil if ware_count == 0  
        # 没有学习记录
        return nil if ware_reading_count == 0
        # 所有课件都有学习记录且所有的学习记录都是学习 100%
        return nil if read_percent_of_user(user) == 100
        # 最后的学习记录学习了 100%
        if ware_readings.where(:creator_id => user.id.to_s).last.read_percent == 100
          last_read_chapter = ware_readings.where(:creator_id => user.id.to_s).last.chapter
          if last_read_chapter.read_percent_of_user(user) != 100
            p 11111
            unread_wares = last_read_chapter.wares.select do |ware|
              if ware.read_percent_of_user(user) == 0
                ware
              end
            end
            p unread_wares
            return unread_wares.first
          else
            unread_chapters = chapters.select do |chapter|
              if chapter.read_percent_of_user(user) == 0
                chapter
              end
            end
            return unread_chapters.first.wares.first
          end
        else
        # 最后的学习记录没有学习 100%
          ware_readings.where(:creator_id => user.id.to_s).last.ware
        end
      end
    end
  end
end
