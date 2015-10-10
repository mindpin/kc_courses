User.has_many :courses, class_name: 'KcCourses::Course'
User.has_many :chapters, class_name: 'KcCourses::Chapter'
User.has_many :wares, class_name: 'KcCourses::Ware'
User.has_many :favorites, class_name: 'KcCourses::Favorite'
