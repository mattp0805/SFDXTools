# SFDXTools v 1.1.0
Hammerspoon tools for Salesforce Development Console

## Installation

### Install Hammerspoon

Go to [Hammerspoon's Get Started Page](https://www.hammerspoon.org/go/) and follow the instructions under **Setup**.

### Download and Install the Spoon

- Go to **Releases** on the right hand side of Github and select the most recent version. 
- Click on the Zip file in **Assets** to start the download.
- Unzip the file.
- Double-click the SFDXTools.spoon file in the uncompressed folder to install. 

## Setup

To configure Hammerspoon, you need to edit the **init.lua** file in *~/.hammerspoon/*.

As described in the docs.json file, there are a few properties and methods available to the end user including the style of the List popup, and the duration that it stays on screen. I won’t describe them all here, but will explain the basic hotkey setup. 

1. Load the SDFXTools Spoon by adding `hs.loadSpoon("SFDXTools")` at the bottom of your **init.lua**.
2. Enter a new line that reads `spoon.SFDXTools:bindHotKeys({{ "cmd", "alt", "ctrl" }, "s"})`. This will bind the shortcut Command,Option,Control + S to the modal launcher.
3. You can change the binding by passing a different combination of keys, this will always be in the form of a table containing two items, a table of special keys and a standalone character. E.g. `{{"cmd", "alt"}, "l"}` 


## Usage

- You must bind the hotkeys using `SFDXTools:bindHotKeys()` in order to access the modal.
- Entering 'list' (the default value) into the modal before hitting OK will print to screen a list of Non-Scratch Orgs that you have authorised via SFDX, along with their status. 
- Entering the Alias or Username of the authorised org will open a new tab in your browser logged into the org, but only if the status of the connection is 'Connected'.  

## Troubleshooting

- If nothing happens once you've pressed OK on the modal, or you recieve the following a `Unable to launch hs.task process: Couldn't posix_spawn: error 13` error in the console, it may be that SFDX is installed in a different place than expected. Set SFDXPATH to the path of your SFDX binary. The default is '/usr/local/bin/sfdx'. 
- The list functionality can be quite slow. Give it a good minute before assuming there's an issue.
- If the modal does not appear, there may have been an error binding the hotkey, check the console for details or try a different combination.



