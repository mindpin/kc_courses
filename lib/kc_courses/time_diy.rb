module KcCourses
  class TimeDiy
    def self.pretty_seconds(seconds)
      case seconds.to_i
      when 0...60
        "1分钟"
      when 60...3600
        "#{seconds.to_i / 60}分钟"
      when 3600...86400
        "#{seconds.to_i / 3600}小时#{TimeDiy.pretty_seconds(seconds.to_i % 3600)}"
      when 86400...31536000
        "#{seconds.to_i / 86400}天#{TimeDiy.pretty_seconds(seconds.to_i % 86400)}"
      when 31536000..99999999999
        "#{seconds.to_i / 31536000}年#{TimeDiy.pretty_seconds(seconds.to_i % 31536000)}"
      end
    end
  end
end
