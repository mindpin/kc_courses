FilePartUpload.config do
  mode :qiniu

  qiniu_bucket         ENV['qiniu_bucket']
  qiniu_domain         ENV['qiniu_domain']
  qiniu_base_path      ENV['qiniu_base_path']
  qiniu_app_access_key ENV['qiniu_app_access_key']
  qiniu_app_secret_key ENV['qiniu_app_secret_key']
  qiniu_callback_host  ENV['qiniu_callback_host']
end
