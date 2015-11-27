module KcCourses
  class Chapter
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::MovePosition
    include KcCourses::Concerns::ChapterReadingMethods

    field :title, :type => String
    field :desc, :type => String

    belongs_to :course, class_name: 'KcCourses::Course'
    belongs_to :user

    validates :title, :presence => true
    validates :course,  :presence => true
    validates :user, presence: true

    has_many :wares, class_name: 'KcCourses::Ware'
    #has_many :questions
    #has_many :practices

    # 重写MovePosition
    def parent
      course
    end

    before_validation :set_default_value
    def set_default_value
      self.title = "无标题章节 - #{Time.now}" if self.title.blank?
    end

    #def course_wares_read_stat_of(user)
      #scope = self.course_wares.joins(%~
      #LEFT OUTER JOIN course_ware_readings
      #ON course_ware_readings.user_id = #{user.id}
      #AND course_ware_readings.course_ware_id = course_wares.id
                                      #~)

      #none = scope.where('course_ware_readings.read_count = ? OR course_ware_readings.read_count IS NULL', 0).count
      #read = scope.where('course_ware_readings.read_count = course_wares.total_count').count
      #reading = self.course_wares.count - none - read

      #return {
        #:none => none,
        #:read => read,
        #:reading => reading
      #}
    #end

    #def import_javascript_course_ware_from_json(json_data, user)
      #hash_data = JSON.parse(json_data)

      #CourseWare.transaction do
        #course_ware = course_wares.create(
          #{
            #:creator => user,
            #:title => hash_data['title'],
            #:desc => hash_data['desc'],
            #:kind => hash_data['kind']
          #}, { :as => :import }
        #)

        #hash_data['steps'].each do |s|
          #course_ware.javascript_steps.create(
            #:content => s['content'],
            #:rule => s['rule'],
            #:title => s['title'],
            #:desc => s['desc'],
            #:hint => s['hint'],
            #:init_code => s['init_code'],
            #:code_reset => s['code_reset'].nil? ? true : s['code_reset']
          #)
        #end

        #course_ware.refresh_total_count!

        #course_ware
      #end

    #end
  end
end
