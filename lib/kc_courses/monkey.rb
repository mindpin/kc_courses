module KcCourses
  module Monkey
    def good_as_json(options=nil)
      tmp_json = as_json(options)
      tmp_json['id'] = tmp_json['_id'].good_as_json if tmp_json['_id']
      tmp_json.delete '_id'

      tmp_json.dup.each do |key, val|
        case val.class.name
        when 'Hash'
          # 多级的情况，会识别不出是BSON::ObjectId 所以需要特殊处理
          if val['$oid']
            tmp_json[key] = val['$oid'].to_s
          else
            tmp_json[key] = val.good_as_json
          end
        when 'Array', 'BSON::ObjectId'
          tmp_json[key] = val.good_as_json
        end
      end
      tmp_json
    end
  end
end

class Array
  def good_as_json(options=nil)
    map(&:good_as_json)
  end
end

class Hash
  include KcCourses::Monkey
end

module Mongoid
  module Document
    include KcCourses::Monkey
  end
end

module BSON
  class ObjectId
    def good_as_json(options=nil)
      self.to_s
    end
  end
end
