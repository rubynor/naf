
class window.Uploader extends Backbone.View
  initialize: (options) ->
    @doneIds = new Array() # keep track of done uploads
    @multiple = false
    @content_type = "application/octet-stream" # Videos would be binary/octet-stream
    filter_title = 'Images (*.jpg, *.gif, *.png, *.bmp)'
    filter_extentions = 'jpg,jpeg,gif,png,bmp'
    @key = "temp"
    that = @
    if options
      @multiple = options.multiple if options.multiple
      @key = options.key if options.key

    @uploader = new plupload.Uploader({
      runtimes : 'flash,silverlight',    #html5,  'gears,html5,flash,silverlight,browserplus',
      browse_button : 'pickfiles',
      container: 'upload_container'
      max_file_size : '5mb',
      url : "/admin/upload",
      flash_swf_url : '/lib/plupload.flash.swf',
      silverlight_xap_url : '/lib/plupload.silverlight.xap',
      filters : [ {title: "#{filter_title} ", extensions : "#{filter_extentions}"}]
      multi_selection: that.multiple,
      multipart: true,
      multipart_params: {
        "authenticity_token" : FORM_AUTH_TOKEN
      },
      file_data_name: 'photo'
    })
    @uploader.bind 'Init', (up, params) ->
      $('#filelist').html("<div>Current runtime: #{params.runtime} </div>")
    @uploader.init();
    @setupBindings()


  setupBindings: ->
    #instantiates the uploader
    that = @
    #@uploader.bind 'Init', (up) ->
    #  $("#runtime").html up.runtime

    # shows the progress bar and kicks off uploading
    @uploader.bind 'FilesAdded', (up, files) ->
      _.each files, (file) ->

        $('#filelist').append('<div id="' + file.id + '"><small>' + file.name + ' (' + plupload.formatSize(file.size) + ') </small><b></b>' + '<div class=" percent label notice" style="width:10%;"><span>Laster opp</span></div></div>')
      #up.refresh(); # Reposition Flash/Silverlight

      #$('#progress_bar .ui-progress').css('width', '5%')
      #$('span.ui-label').show()

      #start the uploader after the progress bar shows
      #$('#progress_bar').show 'fast', ->
      that.uploader.start();

    #binds progress to progress bar
    @uploader.bind 'UploadProgress', (uploader, file) ->

      if(file.percent < 100)
        $("#filelist ##{file.id} .percent").css('width', file.percent+'%')
      else
        unless that.doneIds.indexOf(file.id) > -1
          that.doneIds.push file.id
          $("#filelist ##{file.id} .percent").css('width', '100%')
          $("#filelist ##{file.id} .percent").removeClass("notice").addClass("success")
          $("#filelist ##{file.id} .percent span").text('Ferdig.')
          $("#filelist ##{file.id}").fadeOut()
          console.log("finished uploading file id=#{file.id}")

    @uploader.bind 'FileUploaded', (up, file, response) ->
      res = JSON.parse(response.response)
      url = res.photo.photo.thumb.url
      id = res.photo._id
      $("#image_preview").attr("src", url)
      $("#activity_photo_id").val(id)

    #shows error object in the browser console (for now)
    @uploader.bind 'Error', (up, error) ->
      #console.log("sug")
      console.log error
      alert("Det oppstod en feil i opplasting. Kontakt service dersom problemet fortsetter.")

