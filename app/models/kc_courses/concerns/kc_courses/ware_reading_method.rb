module KcCourses
  module WareReadingMethod
    extend ActiveSupport::Concern
    KcCourses::WareReadingMethod
    
    # 设置 user 已经完成了 course/chapter/ware 百分之 read_percent 的内容
    def set_read_percent_by_user(user, read_percent)
      ware_readings.create(:creator => user, :read_percent => read_percent)
    end
    # 设置 user 在某一天内 course/chapter/ware 的学习进度变化
    def set_read_percent_by_user(user, read_percent_change, time)
      ware_reading_deltas.create(:creator => user, :read_percent_change => read_percent_change, :time => time)
    end
    
    # user 是否已经完成整个 course/chapter/ware 的学习（read_percent 是 100 时，表示完成学习）
    def has_read_by_user?(user)
      if ware_readings.where(:creator => user).first.read_percent == 100
        return true
      else
        return false
      end
    end

    # user 已经学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
    def read_percent_of_user(user)
      return ware_readings.where(:creator => user).first.read_percent
    end

    # user 某一天内学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
    def read_percent_change_of_user(user, time)
      return ware_reading_deltas.where(:creator => user, :time => time).first.read_percent_change
    end
    
    # user 截止到某天（包括这个某天内学习的），已经学习了 course/chapter/ware 多少百分比的内容，返回值是代表百分比的数字
    def read_percent_change_of_user(user, time)
      return ware_reading_deltas.where(:creator => user, :time => time).first.read_percent
    end

    # 查询该用户某段时间内的学习情况
    def read_status_of_course(start_time, end_time)
      if ware_reading_deltas.time >= start_time && ware_reading_deltas.time <= end_time
        arr = ware_reading_deltas.map
        return arr
      end
    end
  end
end