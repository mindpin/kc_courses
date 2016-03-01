require 'rails_helper'

RSpec.describe KcCourses::Concerns::SubjectMethods, type: :module do
  describe KcCourses::Course do
    before do
      @course = create(:course)
      @course_subject = create(:course_subject)
    end

    it '#has_subject?' do
      expect(@course.has_subject?(@course_subject)).to eq false
      @course.add_subject(@course_subject)
      expect(@course.has_subject?(@course_subject)).to eq true
    end

    it '#add_subject' do
      expect(@course.add_subject(@course_subject)).to_not be_nil
      expect(@course.add_subject(@course_subject)).to be_nil
    end

    it '#remove_subject' do
      expect(@course.remove_subject(@course_subject)).to be_nil
      @course.add_subject(@course_subject)
      expect(@course.remove_subject(@course_subject)).to_not be_nil
      expect(@course.remove_subject(@course_subject)).to be_nil
    end

    it 'relationship' do
      @course.add_subject(@course_subject)
      @course_subject.reload
      expect(@course_subject.courses.include?(@course)).to eq true

      @course.remove_subject(@course_subject)
      @course_subject.reload
      expect(@course_subject.courses.include?(@course)).to eq false
    end
    
  end
end
