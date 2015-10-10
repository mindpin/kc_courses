User.has_many :courses, class_name: 'KcCourses::Course'
User.has_many :chapters, class_name: 'KcCourses::Chapter'
User.has_many :wares, class_name: 'KcCourses::Ware'
User.has_many :joins, class_name: 'KcCourses::Join'
