jQuery(document).on 'ready page:load', ->
  # 请根据实际需求重写这个类
  class QiniuFileProgress
    constructor: (uploading_file, @uploader)->
      @file = uploading_file
      console.log @file
      window.afile = @file

    # 上传进度进度更新时调用此方法
    update: ->
      console.log "qiniu update"
      console.log "#{@file.percent}%"

    # 上传成功时调用此方法
    success: (info)->
      console.log "qiniu success"
      console.log info
      $cover = jQuery('#img_course_cover')

      jQuery('#course_cover').val(info.file_entity_url)

      if $cover.length > 0
        $cover.prop('src', info.file_entity_url) 

      else
        jQuery('.cover_preview').append """
          <img id="img_course_cover" class="img-responsive" src="#{info.file_entity_url}" />
        """

    # 上传出错时调用此方法
    error: ->
      console.log "qiniu error"

    @alldone: ->
      console.log "qiniu alldone"


  if jQuery('.btn-upload').length
    $browse_button = jQuery('.btn-upload')
    $dragdrop_area = jQuery(document.body)

    new FilePartUploader
      browse_button: $browse_button
      dragdrop_area: $dragdrop_area
      file_progress: QiniuFileProgress
