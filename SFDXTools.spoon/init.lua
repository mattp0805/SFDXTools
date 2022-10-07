obj = {}

obj.name = "SFDXTools"
obj.version = "1.0.1"
obj.author = { name = "Matt Port", email = "mattp0@duck.com" }

obj.SFDXPATH = "/usr/local/bin/sfdx"
json = "--json"
obj.ALERTSTYLE = {
    strokeWidth  = 2,
    strokeColor = { white = 1, alpha = 1 },
    fillColor   = { white = 0, alpha = 0.75 },
    textColor = { white = 1, alpha = 1 },
    textFont  = ".AppleSystemUIFont",
    textSize  = 14,
    radius = 27,
    atScreenEdge = 1,
    fadeInDuration = 0.15,
    fadeOutDuration = 0.15,
    padding = nil,
}
obj.ORGLISTDURATION = 6
obj.MAPPING = {{ "cmd", "alt", "ctrl" }, "s"}

function obj:init()
    w = {}
    self.__index = self
    return setmetatable(w , self )
end

function sfdxList(exitCode, stdOut, stdErr)
        if exitCode == 0 then
            jsonResponse = hs.json.decode(stdOut)
            print(jsonResponse.result.nonScratchOrgs[1])
            print(stdOut)
            alertString = stdOut
            hs.alert.show(alertString, obj.ALERTSTYLE, hs.screen.mainScreen(), obj.ORGLISTDURATION )    
                
        else
            hs.alert.show('Error: ' .. stdErr)
        end 
        
end

function sfdxOpen(exitCode, stdOut, stdErr)
    if exitCode == 0 then
       console.log('Opened org')
    else
        hs.alert.show('Error: ' .. stdErr)
    end 
    
end



function obj:startDialog()
    hs.focus()
    button, text = hs.dialog.textPrompt("SFDX", "Enter org to open", "list", "Open", "Cancel", false)
    if button == 'Open' then
        if text == 'list' then
            print(text)
            print(button)
                
                t = hs.task.new(obj.SFDXPATH, sfdxList, {'force:org:list', '--json'})
                t:start()    
        else
                
                t = hs.task.new(obj.SFDXPATH, sfdxOpen, {'force:org:open', text)
                t:start()
            
        end
    end
end

function obj:bindHotKeys()
    spec = obj.MAPPING[1]
    key = obj.MAPPING[2]
    if hs.hotkey.assignable(spec,key) == true then
        hs.hotkey.bind(spec, key, function()
            obj:startDialog()
        end)
        else 
        print("Could not bind keys, try a different combination")
    end
end 
return obj
