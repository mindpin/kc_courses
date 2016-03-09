module KcCourses
  module Concerns
    module CourseStatisticInfo
      extend ActiveSupport::Concern

      def statistic_info
        wares = KcCourses::Ware.where(:chapter_id.in => chapter_ids, :_type => 'KcCourses::SimpleVideoWare')
        total_second = wares.map(&:file_entity).uniq.compact.sum{|fe| fe.seconds.to_i}
        total_minute = total_second / 60
        total_minute = 1 if total_minute == 0 and total_second > 0
        {
          video:{
            count: wares.count,
            total_minute: total_minute
          }
        }
      end

      module ClassMethods
      end
    end
  end
end
