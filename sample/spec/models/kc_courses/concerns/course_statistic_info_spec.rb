require 'rails_helper'

describe KcCourses::Concerns::CourseStatisticInfo, type: 'module' do
  describe KcCourses::Course, type: :model do
    it '#statistic_info' do
      @callback_body = {
        bucket: "fushang318",
        token: "f/aQK4F8rt.mp4",
        file_size: "912220",
        image_rgb: "",
        original: "腾讯网迷你版 2015_9_29 16_11_59.mp4",
        mime: "video/mp4",
        image_width: "",
        image_height: "",
        avinfo_format: "mov,mp4,m4a,3gp,3g2,mj2",
        avinfo_total_bit_rate: "1791016",
        avinfo_total_duration: "4.074646",
        avinfo_video_codec_name: "h264",
        avinfo_video_bit_rate: "1650102",
        avinfo_video_duration: "4.070733",
        avinfo_height: "552",
        avinfo_width: "768",
        avinfo_audio_codec_name: "aac",
        avinfo_audio_bit_rate: "131534",
        avinfo_audio_duration: "4.074667"
      }
      @course = create(:course)
      @chapter = create(:chapter, course: @course)
      @file_entity = FilePartUpload::FileEntity.from_qiniu_callback_body @callback_body

      @ware = create(:ware, chapter: @chapter, file_entity: @file_entity, _type: 'KcCourses::SimpleVideoWare')
      # 1条
      expect(@course.statistic_info).to eq({:video=>{:count=>1, :total_minute=>1}})

      # 30条4秒 = 2分钟
      @count = 30
      (@count - 1).times.each do 
        create(:ware, chapter: @chapter, file_entity: @file_entity, _type: 'KcCourses::SimpleVideoWare')
      end
      {:video=>{:count=>@count, :total_minute=>2}}
    end
  end
end
