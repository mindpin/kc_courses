module KcCourses
  class TeachingExamRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    field :score, type: Float
    field :max_score, type: Float
    # 阅卷人
    field :examiner_name, type: String
    field :desc, type: String
    # 交卷时间
    field :submitted_at, type: Time


    # 阅卷人，视情况看是否需要
    # belongs_to :examiner, class_name: "User"
    # 试卷，集成工程中添加
    # belongs_to :test_paper, class_name: "QuestionBank::TestPaper"
    belongs_to :exam, class_name: 'KcCourses::TeachingExam', inverse_of: :records
    belongs_to :user, class_name: 'KcCourses::TeachingExam', inverse_of: :records

    validates :score, presence: true
    validates :max_score, presence: true
  end
end
