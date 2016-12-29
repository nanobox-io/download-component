# Example Callback called when download occurs
userInitiatedDownloadCb = (os, installerKind)->
  console.log "The user has downloaded the #{os} #{installerKind} CLI"

app = new nanobox.Download()

# Example of using to detect Operating system
app.detectOs() # Returns : "windows", "apple", "linux" or "Unknown OS"

# Example of instantiating the download ui
app.build $(".holder"), userInitiatedDownloadCb
