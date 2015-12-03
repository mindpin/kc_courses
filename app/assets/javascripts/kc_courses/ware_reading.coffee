class @CustomReadingProgress
  
  before_load: ($el) ->
  loaded: ($el, data) ->     
  error: ($el, data) ->
  finally: ($el) ->

class @Ware_reading
  constructor: (@configs) ->
    @selector = @configs['selector']

    if @selector
      @$el = jQuery @selector
      if @$el.length > 0
        jQuery.each @$el, (index) =>
          course_id = jQuery(event.target).data('data-course_id')
          
          jQuery.ajax
          method: "GET"
          url: "/api/courses/#{course_id}/progress"
          type: "json"
          success: (info)=>
            


jQuery(document).on 'ready page:load', ->
  configs =
    progress_class: CustomReadingProgress
    selector: '.course'

  window.ware_reading = new Ware_reading(configs)
  window.ware_reading.load()