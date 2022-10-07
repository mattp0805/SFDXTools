obj = {name = "SFDXTools",
        version = "1.0.0",
        author = { name = "Matt Port", email = "mattp0@duck.com" }
        }
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
            t = hs.task.new("/usr/local/bin/sfdx", function(exitCode, stdOut, stdErr) 
                -- manipulate string before output
                local outputLen = string.len(stdOut)
                local rows = {}
                local rowStart = 1
                while rowStart <= outputLen do
                    local endOfLine = string.find(stdOut, "\n", rowStart)
                    local currentString = string.sub(stdOut,rowStart, endOfLine)
                    local i = 1
                    local currChar = ' '
                    while currChar == ' ' do
                        currChar = string.sub(currentString,i,i)
                        i = i + 1
                    end          
                    i = i - 1
                    local endOfAlias = string.find(currentString, " ", i)
                    print(endOfAlias) 
                    local alias = string.sub(currentString, i, endOfAlias)
                    if alias == "ALIAS " then
                        table.insert(rows, {alias, "Status"})
                    elseif string.find(alias, "─") ~= nil then
                        table.insert(rows,{alias,""})
                    elseif string.find(currentString, "Connected") ~= nil then
                        table.insert(rows, {alias, "Connected"})
                    elseif alias == "No " then
                        table.insert(rows, {currentString, ""}) 
                    elseif alias == "\n" then
                        -- do nothing
                    else
                         table.insert(rows, {alias, "Disconnected"})
                    end
                    rowStart = endOfLine + 1
                    
                end
                for x, y in pairs(rows) do
                    print(y[1].."\t\t\t"..y[2])
                end
                alertString = ""
                for x, y in pairs(rows) do
                    alertString = alertString .. (y[1].."\t\t"..y[2].."\n")
                end
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

                    --[[
                mainScreen = hs.screen.mainScreen()
                screenSize = mainScreen:frame()
                print(screenSize.h)
                print(screenSize.w)
                widgetSize = {w=800, h=400}
                canvasRect = hs.geometry.rect({
                    x=((screenSize.w/2) - (widgetSize.w/2)), 
                    y=((screenSize.h/2) - (widgetSize.h/2)),
                    w = widgetSize.w,
                    h = widgetSize.h
                })
                c = hs.canvas.new(canvasRect):appendElements(
                    {
                        action="fill", 
                        type = "rectangle", 
                        frame={x = 0, y=0, h=widgetSize.h, w=widgetSize.w},
                        fillColor= {hex="F2A44A"},
                    },
                    {
                        action="fill",
                        type="text",
                        frame={x = 0, y=0, h=widgetSize.h, w=widgetSize.w}, 
                        text=stdOut,
                        textSize=14   
                    }):show()
                ]]--    
                end, 
                function(...) return false end,
                {"force:org:list"})
                t:start()
                
    else
        hs.execute("sfdx force:org:open -u" .. text, true)
    end
end

function obj:bindHotKeys(mapping)
    spec = mapping[1]
    key = mapping[2]
    if hs.hotkey.assignable(spec,key) == true then
        hs.hotkey.bind(spec, key, function()
            obj:startDialog()
        end)
    else 
        print("Could not bind keys, try a different combination")
    end
end
return obj
