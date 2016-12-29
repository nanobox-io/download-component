## Download Component

UI component used to download mac / windows / linux versions of the nanobox cli, including an interface for selecting docker native or virtual box.

## Sample usage

``` coffee
# Example Callback called when download occurs
# @os            : apple, windows, etc..
# @installerKind : docker, vBox
userInitiatedDownloadCb = (os, installerKind)->
  console.log "The user has downloaded the #{os} #{installerKind} CLI"

app = new nanobox.Download()

# Example of using to detect Operating system
app.detectOs() # Returns : "windows", "apple", "linux" or "Unknown OS"

# Example of instantiating the download ui
app.build $(".holder"), userInitiatedDownloadCb

# ------------------------------------ Creating OS specific download images

# Building the main download imge
app.getOsBox( $(".os-box") )

# Building the small download image
app.getOsBox( $(".small-os-box"), true )
```
