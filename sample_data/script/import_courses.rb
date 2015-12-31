module KcCourses
  class ImportCourses
    def self.import
      json_courses = IO.read(File.expand_path("../../data/courses.json",__FILE__))
      courses_hash = JSON.parse(json_courses)
      creator = User.create!(:id => "564165656e95521109000001", :email => "123456@qq.com", :password => "123456", :name => "1234")
      reader = User.create!(:id => "564165656e95521109000002", :email => "123467@qq.com", :password => "1234567", :name => "123")
      courses = courses_hash["courses"]
      courses.each do |course|
        KcCourses::Course.create!(:id => course["course_id"], :title => course["title"], :user_id => course["creator_id"])
        chapters = course["chapters"]
        chapters.each do |chapter|
          KcCourses::Chapter.create(:id => chapter["chapter_id"], :title => chapter["title"], :course_id => chapter["course_id"], :user_id => chapter["creator_id"])
          wares = chapter["wares"]
          wares.each do |ware|
            KcCourses::Ware.create(:id => ware["ware_id"], :title => ware["title"], :chapter_id => ware["chapter_id"], :user_id => ware["creator_id"])
            read_ware = KcCourses::Ware.find(ware["ware_id"])
            reader = User.find(ware["reader_id"])
            read_ware.set_read_percent_by_user(reader, ware["read_percent"])
          end
        end
      end
    end
  end
end