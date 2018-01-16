# Example Callback called when download occurs
userInitiatedDownloadCb = (os, installerKind)->
  console.log "The user has downloaded the #{os} #{installerKind} CLI"

new nanobox.Download( $(".holder"), userInitiatedDownloadCb )

# Example of using to detect Operating system
# app.detectOs() # Returns : "windows", "apple", "linux" or "Unknown OS"

# Example of instantiating the download ui
# app.build $(".holder"), userInitiatedDownloadCb

# ------------------------------------ Creating OS specific download images

# Building the main download imge
# app.getOsBox( $(".os-box") )

# Building the small download image
# app.getOsBox( $(".small-os-box"), true )
