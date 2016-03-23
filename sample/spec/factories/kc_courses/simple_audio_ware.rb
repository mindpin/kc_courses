FactoryGirl.define do
  factory :simple_audio_ware, class: KcCourses::SimpleAudioWare do
    sequence(:title){|n| "音频课件#{n}"}
    sequence(:desc){|n| "音频课件#{n} 描述"}
    chapter
    creator {create(:user)}
  end
end
