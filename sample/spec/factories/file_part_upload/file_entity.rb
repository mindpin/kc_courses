FactoryGirl.define do
  factory :file_entity, class: FilePartUpload::FileEntity do
    original "1-120GQF34TY.jpg"
    mime "image/jpeg"
    token "/f/IuR0fINf.jpg"
    meta { {"file_size"=>25067, "image"=>{"rgba"=>"rgba(79,73,81,0)", "hex"=>"#4f4951", "height"=>"200", "width"=>"200"}} }

    factory :audio_file_entity do
      original "car-engine-loop-493679_SOUNDDOGS__au.mp3"
      mime "audio/mp3"
      token "f/G8UB1myy.mp3"
      meta { {"file_size"=>18392, "audio"=>{"total_bit_rate"=>"34771", "total_duration"=>"4.231500", "audio_codec_name"=>"mp3", "audio_bit_rate"=>"32000", "audio_duration"=>"4.231500"}} }
    end

    factory :video_file_entity do
      original "腾讯网迷你版 2015_9_29 16_11_59.mp4"
      mime "video/mp4"
      token "f/aQK4F8rt.mp4"
      meta { {"file_size"=>912220, "video"=>{"format"=>"mov,mp4,m4a,3gp,3g2,mj2", "total_bit_rate"=>"1791016", "total_duration"=>"4.074646", "video_codec_name"=>"h264", "video_bit_rate"=>"1650102", "video_duration"=>"4.070733", "height"=>"552", "width"=>"768", "audio_codec_name"=>"aac", "avinfo_audio_bit_rate"=>"131534", "avinfo_audio_duration"=>"4.074667"}} }
    end
  end
end
