obj = {}

obj.name = "SFDXTools"
obj.version = "1.0.1"
obj.author = { name = "Matt Port", email = "mattp0@duck.com" }

obj.SFDXPATH = "/usr/local/bin/sfdx"


function obj:init()
    w = {}
    self.__index = self
    return setmetatable(w , self )
end

function obj:startDialog()
    hs.focus()
    button, text = hs.dialog.textPrompt("SFDX", "Enter the alias of the org you'd like to open", "list", "OK", "Cancel", false)
    print(text)
    if text == "list" then
            t = nil
            t = hs.task.new(
            -- launch path    
            this.SFDXPATH, 
            --callback function
            function(exitCode, stdOut, stdErr) 
                -- manipulate string before output
                alertString = stdOut
                hs.alert.show(alertString,
                {
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
                },
                hs.screen.mainScreen(),
                6 

                )    
                end, 
                -- streamCallback
                function(...) return false end,
                -- args for sfdx
                {"force:org:list", "--json"})

                t:start()
                
    else
        hs.execute("sfdx force:org:open -u" .. text, true)
    end
end

function obj:bindHotKeys(mapping)
    spec = mapping[1]
    key = mapping[2]
    if hs.hotkey.assignable(spec,key) == true then
        hs.hotkey.bind(spec, key, obj:startDialog())
    else 
        print("Could not bind keys, try a different combination")
    end
end
return obj
