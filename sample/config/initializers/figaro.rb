if !File.exists?(Rails.root.join("config/application.yml"))
  p "******************************************"
  p "* 缺少                                   *"
  p "* config/application.yml 配置文件      *"
  p "*                                        *"
  p "* 请参考                                 *"
  p "* config/application.yml.development   *"
  p "* 创建配置文件                           *"
  p "******************************************"

  exit 0
end

configs = %w{
  qiniu_bucket
  qiniu_domain
  qiniu_base_path
  qiniu_app_access_key
  qiniu_app_secret_key
  qiniu_callback_host
}

configs.each do |config|
  if ENV[config].blank?
    p "!请在 config/application.yml 中增加 #{config} 配置"
    exit 0
  end
end
