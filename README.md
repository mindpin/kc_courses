# kc_courses

课程管理

## 安装

Gemfile  
```ruby
gem 'kc_courses', :github => 'mindpin/kc_courses',
                  :branch => "master"
# 依赖
gem 'mongoid-tree', :require => 'mongoid/tree'
```

## 配置

在 `config/routes.rb` 增加
```ruby
Rails.application.routes.draw do
  mount KcCourses::Engine => '/kc_courses'
end
```

## 使用

TODO
