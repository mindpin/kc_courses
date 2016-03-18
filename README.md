# kc_courses

课程管理

## 安装

Gemfile  
```ruby
gem 'kc_courses', :github => 'mindpin/kc_courses',
                  :branch => "master"
# 依赖
gem 'file-part-upload',
  :github => "mindpin/file-part-upload",
  :tag    => "2.2.2"
```

## 配置

### file-part-upload 配置
请查看

[file-part-upload说明](https://github.com/mindpin/file-part-upload/wiki/%E7%94%A8-qiniu-%E4%BD%9C%E4%B8%BA%E5%90%8E%E5%8F%B0%E5%AD%98%E5%82%A8%E7%9A%84%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)

### 路由
在 `config/routes.rb` 增加
```ruby
Rails.application.routes.draw do
  mount KcCourses::Engine => '/kc_courses'
end
```

### 环境变量(ENV)
推荐使用 [figaro](https://github.com/laserlemon/figaro)
```
# config/application.yml
# 课程默认封面地址
course_default_cover_url: 'http://xxxx.xxx/xxx.png'
```
或通过其他形式，设置 ENV['course_default_cover_url']

### 代码
在app/models/user.rb中
```ruby
include KcCourses::Concerns::UserTeachingGroupMethods
```

## 使用

TODO
