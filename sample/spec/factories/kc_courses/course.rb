FactoryGirl.define do
  factory :course, class: KcCourses::Course do
    title "课程1"
    desc "课程1 描述"
    user
  end


  # 客户信息
  # 第一章客户信息管理
  # 1_1_客户账户调整
  # 1_2_测试菜单
  # 第二章查询客户信息
  # 2_1_查询客户号
  # 2_2_查询客户账户调整
  # 2_3_查询客户信息维护
  # 2_4_查询个人客户基本信息
  # 2_5_查询单位客户基本信息
  # 第三章建立客户信息
  # 3_1_新建个人客户基本信息
  # 3_2_新建对公客户基本信息
  # 3_3_编不下去了
  factory :course_客户信息, class: KcCourses::Course do
    title "客户信息"
    association :user, factory: :user_course_creator
  end

  factory :chapter_第一章客户信息管理, class: KcCourses::Chapter do
    title "第一章客户信息管理"
    association :user, factory: :user_course_creator
    association :course, factory: :course_客户信息
  end

  factory :ware_1_1_客户账户调整, class: KcCourses::Ware do
    title "1_1_客户账户调整"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第一章客户信息管理
  end

  factory :ware_1_2_测试菜单, class: KcCourses::Ware do
    title "1_2_测试菜单"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第一章客户信息管理
  end

  factory :chapter_第二章查询客户信息, class: KcCourses::Chapter do
    title "第二章查询客户信息"
    association :user, factory: :user_course_creator
    association :course, factory: :course_客户信息
  end

  factory :ware_2_1_查询客户号, class: KcCourses::Ware do
    title "2_1_查询客户号"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第二章查询客户信息
  end

  factory :ware_2_2_查询客户账户调整, class: KcCourses::Ware do
    title "2_2_查询客户账户调整"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第二章查询客户信息
  end

  factory :ware_2_3_查询客户信息维护, class: KcCourses::Ware do
    title "2_3_查询客户信息维护"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第二章查询客户信息
  end

  factory :ware_2_4_查询个人客户基本信息, class: KcCourses::Ware do
    title "2_4_查询个人客户基本信息"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第二章查询客户信息
  end

  factory :ware_2_5_查询单位客户基本信息, class: KcCourses::Ware do
    title "2_5_查询单位客户基本信息"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第二章查询客户信息
  end

  factory :chapter_第三章建立客户信息, class: KcCourses::Chapter do
    title "第三章建立客户信息"
    association :user, factory: :user_course_creator
    association :course, factory: :course_客户信息
  end

  factory :ware_3_1_新建个人客户基本信息, class: KcCourses::Ware do
    title "3_1_新建个人客户基本信息"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第三章建立客户信息
  end

  factory :ware_3_2_新建对公客户基本信息, class: KcCourses::Ware do
    title "3_2_新建对公客户基本信息"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第三章建立客户信息
  end

  factory :ware_3_3_编不下去了, class: KcCourses::Ware do
    title "3_3_编不下去了"
    association :user, factory: :user_course_creator
    association :chapter, factory: :chapter_第三章建立客户信息
  end

end
