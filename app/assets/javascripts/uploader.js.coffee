
class window.Uploader extends Backbone.View
  initialize: (options) ->
    @upload_100_file_id = "none" #hack because of FileUploaded called twice # Before it used doneIds = new Array()  - to store uploaded files. # keep track of done uploads
    @uploaded_file_id = "none"
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
      runtimes : 'html5,gears,flash,silverlight,browserplus',
      browse_button : 'pickfiles',
      container: 'upload_container'
      max_file_size : '5mb',
      url : "/admin/upload",
      flash_swf_url : '/publiclib/plupload.flash.swf',
      silverlight_xap_url : '/publiclib/plupload.silverlight.xap',
      filters : [ {title: "#{filter_title} ", extensions : "#{filter_extentions}"}]
      multi_selection: that.multiple,
      multipart: true,
      multipart_params: {
        "authenticity_token" : FORM_AUTH_TOKEN
      },
      file_data_name: 'photo'
    })
    # Print out runtime to test.
    @uploader.bind 'Init', (up, params) ->
      $('#filelist').html("<div class='runtime'>Opplastningsmiljø: #{params.runtime} </div>")
    @uploader.init()
    @setupBindings()


  setupBindings: ->
    #instantiates the uploader
    that = @

    # shows the progress bar and kicks off uploading
    @uploader.bind 'FilesAdded', (up, files) ->
      _.each files, (file) ->

        $('#filelist').append('<div id="' + file.id + '"><small>' + file.name + ' (' + plupload.formatSize(file.size) + ') </small><b></b>' + '<div class=" percent label notice" style="width:10%;"><span>Laster opp</span></div></div>')
      #start the uploader after the progress bar shows
      #$('#progress_bar').show 'fast', ->
#      console.log("starting uploader")
      that.uploader.start()


    #binds progress to progress bar
    @uploader.bind 'UploadProgress', (uploader, file) ->

      if(file.percent < 100)
        $("#filelist ##{file.id} .percent").css('width', file.percent+'%')
      else
        unless that.upload_100_file_id == file.id
          that.upload_100_file_id = file.id
#        unless $.inArray(file.id, that.doneIds) > -1
#          that.doneIds.push file.id
          $("#filelist ##{file.id} .percent").css('width', '100%')
          $("#filelist ##{file.id} .percent").removeClass("notice").addClass("success")
          $("#filelist ##{file.id} .percent span").text('Ferdig opplastet. Vent...')
#          console.log("finished uploading file percent #{file.percent} id=#{file.id}")

    @uploader.bind 'FileUploaded', (up, file, response) ->
      unless that.uploaded_file_id == file.id        # theres a double call problem... uploader started once but this one is called twice
        that.uploaded_file_id = file.id
        res = JSON.parse(response.response)
        url = res.photo.photo.thumb.url
        id = res.photo._id
#        console.log("set img") #{file.id}")
        $("#image_preview").attr("src", url)
        $("#activity_photo_id").val(id)
        $("#filelist ##{file.id}").fadeOut()

    #shows error object in the browser console (for now)
    @uploader.bind 'Error', (up, error) ->
      #console.log("sug")
      console.log error
      alert("Det oppstod en feil i opplasting. Kontakt service dersom problemet fortsetter.")

