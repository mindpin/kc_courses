module KcCourses
  module Concerns
    module PublishedCourseReadingMethods
      extend ActiveSupport::Concern

      # array
      def published_chapters
        @published_chapters ||= data['chapters']
      end

      def published_wares
        @published_wares ||= published_chapters.map{|chapter| chapter['wares']}.flatten
      end

      def read_percent_of_user_with_published_ware(user, published_ware)
        ware = KcCourses::Ware.find published_ware['id']
        ware.read_percent_of_user(user)
      end

      def read_percent_of_user_with_published_chapter(user, published_chapter)
        wares = published_chapter['wares']
        return 100 if wares.length == 0
        total = wares.sum do |ware|
          read_percent_of_user_with_published_ware(user, ware)
        end / (wares.length * 100.0)
        total = total * 100
        total.round
      end

      def read_percent_of_user(user)
        return 0 if published_chapters.blank? or published_wares.blank?

        total = 0.0
        is_read = false
        published_wares.each{ |ware|
          percent = read_percent_of_user_with_published_ware(user, ware)
          total += percent
          is_read = true if percent > 0
        }
        total = total / (published_wares.length * 100.0)

        total = (total * 100).round
        return 1 if total == 0 and is_read
        total
      end

      # user 是否已经完成整个 course 的学习（read_percent 是 100 时，表示完成学习）
      def has_read_by_user?(user)
        read_percent_of_user(user) == 100
      end

      # user 截止到 time 当天（包括当天）已经学习了多少百分比的内容
      def read_percent_of_user_before_day(user, time)
        return 0 if published_chapters.blank? or published_wares.blank?

        total = published_wares.sum{ |p_ware|
          ware = KcCourses::Ware.find p_ware['id']
          ware.read_percent_of_user_before_day(user, time)
        }
        total = total / (published_wares.length * 100.0)
        (total * 100).round
      end

      # user 在 time 当天学习了多少百分比的内容
      def read_percent_change_of_user(user, time)
        return 0 if published_chapters.blank? or published_wares.blank?

        total = published_wares.sum{ |p_ware|
          ware = KcCourses::Ware.find p_ware['id']
          ware.read_percent_change_of_user(user, time)
        }
        total = total / (published_wares.length * 100.0)
        (total * 100).round
      end

      ## user 在当前课程正在学习的课件
      def studing_ware_of_user(user)
        return nil if user == nil
        ware_reading_count = 0
        ware_count = published_wares.length
        first_undead_ware = nil
        published_wares.each do |p_ware|
          ware = KcCourses::Ware.find p_ware['id']
          ware_reading_count = ware_reading_count + ware.ware_readings.count
          first_undead_ware = ware if first_undead_ware.nil? and !ware.has_read_by_user?(user)
        end
        # 没有课件
        return nil if ware_count == 0
        # 没有学习记录
        return nil if ware_reading_count == 0
        # 所有课件都有学习记录且所有的学习记录都是学习 100%
        return nil if has_read_by_user?(user)

        first_undead_ware
      end

      # user 在当前课程的学习时长
      # TODO 原有BUG
      #def spent_time_of_user(user)
        #ware_ids = published_wares.map{|p_ware| p_ware['id']}
        #ware_readings = KcCourses::WareReading.where(:creator_id => user.id.to_s, :ware_id.in => ware_ids).asc(:updated_at)
        #return 0 if ware_readings.count == 0
        #return 1 if ware_readings.count == 1
        #ware_readings.last.updated_at - ware_readings.where(:creator_id => user.id.to_s).first.created_at
      #end

      # 最后学习该课程的时间
      def last_studied_at_of_user(user)
        return nil if user == nil
        ware_ids = published_wares.map{|p_ware| p_ware['id']}
        KcCourses::WareReading.where(:creator_id => user.id.to_s, :ware_id.in => ware_ids).asc(:updated_at).last.try(:updated_at) || nil
      end

    end
  end
end
