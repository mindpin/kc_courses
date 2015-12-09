class CustomReadingProgress
  before_load: ($el) ->
  loaded: ($el, data) ->
  error: ($el, data) ->
  finally: ($el)->

class @WareReading
  constructor: (@configs)->
    @$el = jQuery(config["selector"])
    @progress = new config["progress_class"]()
  
  laod: ()->
    @progress.before_load(@$el)
    course_id = jQuery(configs["selector"]).data("data-course_id")
    @progress.before_load(@$el)
    jQuery.ajax
      url: "/api/courses/#{course_id}/progress"
      method: "GET"
      type: "json"
      success: (data) =>
        @progress.laoded(@$el,data)
        @progress.finally(@$el)
      error: (data) =>
        @progress.error(@$el,data)
        @progress.finally(@$el)

