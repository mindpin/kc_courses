namespace :kc_courses do
  desc '创建课程(从json文件里导入课程数据到数据库KcCourses::Course)'
  task :create_data => [:environment] do
    require File.expand_path("../../../sample_data/script/import_courses.rb",__FILE__)
    KcCourses::ImportCourses.import
  end
end