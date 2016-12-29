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

  switchOs : (@os) ->
    if @$node? then @$node.remove()
    @buildMacOrWindows @os
    @addEventListeners()
    $(".os-menu .os.#{@os}").addClass 'active'
    # If it's linux, change some of the view specifics
    if @os == "linux"
      @$node.addClass 'is-linux'
      @onDownloadCb 'linux', 'default'
    @$node.css opacity:0
    @$node.delay(100).animate {opacity:1}, duration:400

  buildMacOrWindows : (os) ->
    @$node = $ downloadPage( {os:os, details:@osData[@os]} )
    @$el.append @$node
    castShadows @$node
    lexify $(".lexi", @$node)

  downloadNow : () ->
    kind = $("input:radio[name='downloads']:checked").val()
    @onDownloadCb @os, kind
    window.location = @osData[@os]["#{kind}URL"]

  detectOs : () ->
    @os = "Unknown OS"
    if      ( navigator.appVersion.indexOf("Win")   !=-1 ) then @os = "windows"
    else if ( navigator.appVersion.indexOf("Mac")   !=-1 ) then @os = "apple"
    else if ( navigator.appVersion.indexOf("X11")   !=-1 ) then @os = "linux"
    else if ( navigator.appVersion.indexOf("Linux") !=-1 ) then @os = "linux"
    @os = 'linux'

  initOsData : () ->
    @osData =
      apple :
        dockerURL  : "https://s3.amazonaws.com/tools.nanobox.io/installers/v1/mac/Nanobox.pkg"
        vBoxURL    : "https://s3.amazonaws.com/tools.nanobox.io/installers/v1/mac/Nanobox.pkg"
        dockerSize : 137
        vBoxSize   : 130
      windows :
        dockerURL  : "https://s3.amazonaws.com/tools.nanobox.io/installers/v1/windows/NanoboxSetup.exe"
        vBoxURL    : "https://s3.amazonaws.com/tools.nanobox.io/installers/v1/windows/NanoboxSetup.exe"
        dockerSize : 137
        vBoxSize   : 137

  getOsBox : ($el, isSmall) ->
    $osBox = $ osBox( {isSmall:isSmall, os:@os} )
    castShadows $osBox
    $el.append $osBox


window.nanobox ||= {}
nanobox.Download = Download
