downloadPage = require 'jade/download-page'
osBox        = require 'jade/os-box'

class Download

  constructor: ->
    @detectOs()

  build : (@$el, @onDownloadCb=->)->
    @initOsData()
    @switchOs @os

  addEventListeners : () ->
    $("#download-now", @$node).on 'click', (e)=> @downloadNow()
    $(".os-menu .os", @$node).on 'click', (e)=>
      # @$node.animate {opacity:0}, duration:10, complete:()=>
      @switchOs e.currentTarget.dataset.id
    $(".download-kinds .kind", @$node).on 'click', (e)=>
      return if e.target.tagName.toUpperCase() == 'INPUT'
      $input = $("input", $(e.currentTarget))
      $input.trigger 'click'
      @$node.removeClass 'docker vBox'
      @$node.addClass $input.val()
    $("#go-back").on 'click', ()-> history.back()

  switchOs : (@os) ->
    if @$node? then @$node.remove()
    @loadJadeTemplate @os
    @addEventListeners()
    $(".os-menu .os.#{@os}").addClass 'active'
    # If it's linux, change some of the view specifics
    if @os == "linux"
      @$node.addClass 'is-linux'
    @$node.css opacity:0
    @$node.delay(100).animate {opacity:1}, duration:400

  loadJadeTemplate : (os) ->
    @$node = $ downloadPage( {os:os, details:@osData[@os]} )
    @$el.append @$node
    castShadows @$node
    lexify $(".lexi", @$node)

  downloadNow : () ->
    if @os == 'linux'
      kind     = $("#linux-flavor").val()
      location = @osData.linux[kind]
    else
      kind     = $("input:radio[name='downloads']:checked").val()
      location = @osData[@os]["#{kind}URL"]

    @onDownloadCb @os, kind
    window.location = location

  detectOs : () ->
    @os = "Unknown OS"
    if      ( navigator.appVersion.indexOf("Win")   !=-1 ) then @os = "windows"
    else if ( navigator.appVersion.indexOf("Mac")   !=-1 ) then @os = "apple"
    else if ( navigator.appVersion.indexOf("X11")   !=-1 ) then @os = "linux"
    else if ( navigator.appVersion.indexOf("Linux") !=-1 ) then @os = "linux"

  initOsData : () ->
    @osData =
      apple :
        dockerURL    : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/mac/Nanobox.pkg" #14mb
        vBoxURL      : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/mac/NanoboxBundle.pkg" #100mb
        dockerSize   : 137
        vBoxSize     : 130
        dockerMsg    :
          main : "Note! We don't recommend using Docker Native for Mac until it's <a href='https://github.com/docker/for-mac/issues/77'>performance issues</a> are resolved."
          sub  : "Note : Not Recommended<br/><br/>Nanobox.pkg - 14mb</br>Requires Docker Native"
        virtualBxMsg :
          main : "Only install Nanobox, we install Virtual Box automatically"
          sub  : "NanoboxBundle.pkg - 100mb"
      windows :
        dockerURL    : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/windows/NanoboxSetup.exe" # 10mb
        vBoxURL      : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/windows/NanoboxBundleSetup.exe" #95
        dockerSize   : 137
        vBoxSize     : 137
        dockerMsg    :
          main : "Requires Docker Native.<br/>Note : we see slightly lower performance using Docker Native vs Virtual Box"
          sub  : "NanoboxSetup.exe - 14mb<br/>Require Docker Nativeulp"
        virtualBxMsg :
          main : "Only install Nanobox, we install Virtual Box automatically"
          sub  : "NanoboxBundleSetup.exe - 95mb"
      linux :
        rpm : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/linux/nanobox-2-1.x86_64.rpm" #14mb
        deb : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/linux/nanobox_2_amd64.deb" # 14mb
        pac : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/linux/nanobox-2-1-x86_64.pkg.tar.xz" #10mb
        tar : "https://d1ormdui8qdvue.cloudfront.net/installers/v2/linux/nanobox-2.tar.gz" #14

  getOsBox : ($el, isSmall) ->
    $osBox = $ osBox( {isSmall:isSmall, os:@os} )
    castShadows $osBox
    $el.append $osBox


window.nanobox ||= {}
nanobox.Download = Download
