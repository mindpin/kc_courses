class @CustomReadingProgress
  before_load: ($el)->
  loaded: ($el, data) ->
  error: ($el, data) ->
  finally: ($el)->

class WareReading
  function: (data,status,$el) ->
    @before_load($el)
    @loaded($el,data) if (status == "success")
    @error($el,data) if (status == "error")
    @finally($el)

jQuery(document).on 'ready page:load', ->
  configs = 
    progress_class: CustomReadingProgress
    selector: '.course'

  window.ware_reading = new WareReading(configs)
  $course = jQuery(@configs["selector"])
  course_id = jQuery(@configs["selector"]).data("data-course_id")
  url = "/api/courses/#{course_id}/progress"
  window.ware_reading.load(url,@function(respone,status,$course))