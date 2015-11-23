module KcCourses
  module Concerns
    module WareReadingMethod
      extend ActiveSupport::Concern
      #计算user 已经完成了 ware 百分之 read_percent 的内容后，该ware所在的course的学习进度
      def read_percent_of_course_now(user, read_percent)
        ware_count_of_chapter = chapter.wares.count
        chapter_count_of_course = chapter.course.chapters.count
        read_percent_change_of_course = read_percent/ware_count_of_chapter/chapter_count_of_course
        read_percent_of_course_before = chapter.course.read_percent_of_user(user)
        return read_percent_of_course_now = read_percent_of_course_before + read_percent_change_of_course
      end

      #计算user 已经完成了 ware 百分之 read_percent 的内容后，该ware所在的chapter的学习进度
      def read_percent_of_chapter_now(user, read_percent)
        ware_count_of_chapter = chapter.wares.count
        read_percent_change_of_chapter = read_percent/ware_count_of_chapter
        read_percent_of_chapter_before = chapter.read_percent_of_user(user)
        return read_percent_of_chapter_count = read_percent_of_chapter_before + read_percent_change_of_chapter
      end

      # 设置 user 已经完成了 course/chapter/ware 百分之 read_percent 的内容
      def set_read_percent_by_user(user, read_percent)
        read_percent_of_chapter_now = read_percent_of_chapter_now(user, read_percent)
        read_percent_of_course_now = read_percent_of_course_now(user, read_percent)
        if chapter.read_percent_of_user(user) == 0
          chapter.ware_readings.create(:creator => user, :read_percent => read_percent_of_chapter_now)
        else
          chapter.ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent_of_chapter_now)
        end

        if chapter.course.read_percent_of_user(user) == 0
          chapter.course.ware_readings.create(:creator => user, :read_percent => read_percent_of_course_now)
        else
          chapter.course.ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent_of_course_now)
        end

        if read_percent_of_user(user) == 0
          return ware_readings.create(:creator => user, :read_percent => read_percent)
        else
          return ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent)
        end
      end

      # 设置 user 在某一天内 course/chapter/ware 的学习进度变化
      def set_read_percent_change_by_user(user, read_percent_change, time)
        if ware_reading_deltas.where(:creator_id => user.id.to_s).count != 0
          read_percent_before = 0
          ware_reading_deltas.map do |ware_reading_delta|
            if ware_reading_delta.time < time.beginning_of_day
              read_percent_before = read_percent_before + ware_reading_delta.read_percent_change
            end
          end
 
          read_percent = read_percent_before + read_percent_change
          read_percent_of_chapter_now = read_percent_of_chapter_now(user, read_percent)
          read_percent_of_course_now = read_percent_of_course_now(user, read_percent)

          ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent)
          chapter.ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent_of_chapter_now)
          chapter.course.ware_readings.where(:creator_id => user.id.to_s).update(:read_percent => read_percent_of_course_now)
          
          chapter.ware_reading_deltas.create(:creator => user, :read_percent_change => read_percent_change, :time => time.beginning_of_day, :read_percent => read_percent_of_chapter_now)
          chapter.ware_reading_deltas.create(:creator => user, :read_percent_change => read_percent_change, :time => time.beginning_of_day, :read_percent => read_percent_of_course_now)
          return ware_reading_deltas.create(:creator => user, :read_percent_change => read_percent_change, :time => time.beginning_of_day, :read_percent => read_percent)
        else
          set_read_percent_by_user(user, read_percent_change)
          return ware_reading_deltas.create(:creator => user, :read_percent_change => read_percent_change, :time => time.beginning_of_day, :read_percent => read_percent_change)
        end
      end

      # user 是否已经完成整个 course/chapter/ware 的学习（read_percent 是 100 时，表示完成学习）
      def has_read_by_user?(user)
        if read_percent_of_user(user) == 100
          return true
        else
          return false
        end
      end

      # user 已经学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
      def read_percent_of_user(user)
        return ware_readings.where(:creator_id => user.id.to_s).first.try(:read_percent) || 0
      end

      # user 某一天内学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
      def read_percent_change_of_user(user, time)
        return ware_reading_deltas.where(:creator_id => user.id.to_s, :time => time.beginning_of_day).first.try(:read_percent_change) || 0
      end

      # user 截止到某天（包括这个某天内学习的），已经学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
      def read_percent_of_user_before_time(user, time)
        return ware_reading_deltas.where(:creator_id => user.id.to_s, :time => time.beginning_of_day).first.try(:read_percent) || 0
      end
    end
  end
end
