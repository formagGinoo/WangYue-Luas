FightBtnManager = BaseClass("FightBtnManager")

local DefaultConfig = 
{
    ChoseType = 1 ,
        ["1"]=
        {
            ["F"]={alpha = 1.0,posy =289.6,posx =-493.7,type =1,scale =0.45},
            ["I"]={alpha = 1.0,posy =250.7,posx =-394.8,type =1,scale =1.2},
            ["X"]={alpha =1.0,posy =99.39999,posx =-125.0996,type =2,scale =1.0},
            ["RoleGroup"]={alpha =1.0,posy =-215,posx =-79.03711,type =102,scale =1.0},
            ["L"]={alpha =1.0,posy =197.6,posx =-535.3,type =1,scale =1.2},
            ["K"]={alpha =1.0,posy =100.1,posx =-420.6,type =1,scale =1.2},
            ["J"]={alpha =1.0,posy =149.8,posx =-264.4,type =1,scale =1.58},
            ["HP"]={alpha =1.0,posy =74.79999,posx =12.4,type =101,scale =1.0},
            ["JR"]={alpha =1.0,posy =243.1,posx =-125.1,type =2,scale =1.0},
            ["ClimbRun"]={alpha =1.0,posy =99.39999,posx =-270.9,type =2,scale =1.0},
            ["SW"]={alpha =1.0,posy =99.70001,posx =-420.7,type =3,scale =1.0},
            ["Joystick"]={alpha =1.0,posy =175,posx =200,type =100,scale =1.0},
            ["O"]={alpha =1.0,posy =242,posx =-124.6,type =1,scale =1.2},
            ["R"]={alpha =1.0,posy =316.9,posx =-257.1,type =1,scale =1.2},
            ["Map"]={alpha =1.0,posy =-94.00024,posx =129.7001,type =1000,scale =1},
            ["TaskButton"]={alpha =1.0,posy =-165.2,posx =44.48499,type =1000,scale =1},
            ["TeachBtn"]={alpha =1.0,posy =-41.14999,posx =231.84,type =1000,scale =1},
            ["MainMenuButton"]={alpha =1.0,posy =-40.16998,posx =-79.8501,type =1000,scale =1.0},
            ["RoleButton"]={alpha =1.0,posy =-40.17078,posx =-167.4398,type =1000,scale =1.0},
            ["BagButton"]={alpha =1.0,posy =-40.16956,posx =-254.49,type =1000,scale =1.0},
            ["AdventureButton"]={alpha =1.0,posy =-40.64398,posx =-341.05,type =1000,scale =1.0}
        },
        ["3"]=
        {
            ["I"]={alpha =1.0,posy =163.13320922852,posx =-300.76220703125,type =1,scale =1.0},
            ["X"]={alpha =1.0,posy =9.1331787109375,posx =-23.76220703125,type =2,scale =1.0},
            ["RoleGroup"]={alpha =1.0,posy =-137.75,posx =-19.0,type =102,scale =1.0},
            ["L"]={alpha =1.0,posy =7.1331787109375,posx =-460.76220703125,type =1,scale =1.0},
            ["K"]={alpha =1.0,posy =9.1331787109375,posx =-338.76220703125,type =1,scale =1.0},
            ["J"]={alpha =1.0,posy =47.699981689453,posx =-169.39999389648,type =1,scale =1.6499999761581},
            ["HP"]={alpha =1.0,posy =0.0,posx =-24.0,type =101,scale =1.0},
            ["JR"]={alpha =1.0,posy =143.13320922852,posx =-23.76220703125,type =2,scale =1.0},
            ["SW"]={alpha =1.0,posy =9.1331787109375,posx =-338.76220703125,type =3,scale =1.0},
            ["Joystick"]={alpha =1.0,posy =95.0,posx =140.0,type =100,scale =1.0},
            ["O"]={alpha =1.0,posy =143.13320922852,posx =-23.76220703125,type =1,scale =1.0},
            ["R"]={alpha =1.0,posy =222.13319396973,posx =-157.76220703125,type =1,scale =1.0},
        },
        ["2"]=
        {
            ["F"]={alpha = 1.0,posy =163.13320922852,posx =-300.76220703125,type =1,scale =0},
            ["I"]={alpha =1.0,posy =150.3,posx =-177.6,type =1,scale =0.78},
            ["X"]={alpha =1.0,posy =9.1331787109375,posx =-23.76220703125,type =2,scale =1.0},
            ["RoleGroup"]={alpha =1.0,posy =-210,posx =-80.0,type =102,scale =0.6},
            ["L"]={alpha =1.0,posy =153.3,posx =-88.4,type =1,scale =1.0},
            ["K"]={alpha =1.0,posy =323.6,posx =-79.1,type =1,scale =0.6},
            ["J"]={alpha =1.0,posy =60,posx =-89,type =1,scale =0.85},
            ["HP"]={alpha =1.0,posy =65.5,posx =0,type =101,scale =0.7},
            ["JR"]={alpha =1.0,posy =143.13320922852,posx =-23.76220703125,type =2,scale =1.0},
            ["SW"]={alpha =1.0,posy =9.1331787109375,posx =-338.76220703125,type =3,scale =1.0},
            ["Joystick"]={alpha =1.0,posy =95.0,posx =140.0,type =100,scale =0},
            ["O"]={alpha =1.0,posy =258.2,posx =-79.2,type =1,scale =0.6},
            ["R"]={alpha =1.0,posy =59.79999,posx =-178.9,type =1,scale =0.85},
            ["Map"]={alpha =1.0,posy =-86,posx =130.5,type =1000,scale =0.8},
            ["TaskButton"]={alpha =1.0,posy =-142.2,posx =58.6,type =1000,scale =0.78},
            ["TeachBtn"]={alpha =1.0,posy =-43.6,posx =211.4,type =1000,scale =0.78},
            ["MainMenuButton"]={alpha =1.0,posy =-40.2,posx =-67.9,type =1000,scale =0.85},
            ["RoleButton"]={alpha =1.0,posy =-40.17078,posx =-139.6,type =1000,scale =0.8},
            ["BagButton"]={alpha =1.0,posy =-40.16956,posx =-207.6,type =1000,scale =0.8},
            ["AdventureButton"]={alpha =1.0,posy =-40.5,posx =-277.1,type =1000,scale =0.8}
        }
}

function FightBtnManager:__init(fight)
    self.fight = fight
    self.clientFight = fight.clientFight
    self.json = self:CreateJson()
    self.BtnConfig = {}

    self.screenWidth = Screen.width/2
    self.screenHeight = Screen.height/2

    self.BtnDict = {}
    self:ReadConfig()

end

function FightBtnManager:__delete()
    
end

function FightBtnManager:InitPlane()
    self.mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	self.skillPanel = self.mainUI.panelList["FightNewSkillPanel"]
    self.FightFormationPanel = self.mainUI.panelList["FightFormationPanel"]
    self.FightInfoPanel = self.mainUI.panelList["FightInfoPanel"]
    self.FightJoyStickPanel = self.mainUI.panelList["FightJoyStickPanel"]
    self.FightSystemPanel = self.mainUI.panelList["FightSystemPanel"]
	self.uiCamera = ctx.UICamera
    self:SetFightBtn(self.type)
end

function FightBtnManager:SetFightBtn(type)
    -- self.type = type
    -- self.BtnDict = self.BtnConfig[tostring(self.type)]
    -- for key,value in pairs(self.BtnDict) do
	-- 	if value.type < 100 then 
    --         self.skillPanel[key.."_rect"].anchoredPosition = {x = value.posx, y = value.posy}
	-- 		self.skillPanel[key.."_rect"].localScale = Vec3.New(value.scale,value.scale,value.scale)
    --         self.skillPanel[key.."_canvas"].alpha = value.alpha
    --     elseif value.type == 100 then
    --         self.FightJoyStickPanel.JoystickArea_rect.anchoredPosition = {x = value.posx, y = value.posy}
	-- 		self.FightJoyStickPanel.JoystickArea_rect.localScale = Vec3.New(value.scale,value.scale,value.scale)
    --         self.FightJoyStickPanel.JoystickArea_canvas.alpha = value.alpha
    --     elseif value.type == 101 then
    --         self.FightInfoPanel.HP_rect.anchoredPosition = {x = value.posx, y = value.posy }
	-- 		self.FightInfoPanel.HP_rect.localScale = Vec3.New(value.scale,value.scale,value.scale)
    --         self.FightInfoPanel.HP_canvas.alpha = value.alpha
    --     elseif value.type == 102 then
    --         self.FightFormationPanel.RoleGroup_rect.anchoredPosition = {x = value.posx, y = value.posy}
	-- 		self.FightFormationPanel.RoleGroup_rect.localScale = Vec3.New(value.scale,value.scale,value.scale)
    --         self.FightFormationPanel.RoleGroup_canvas.alpha = value.alpha
    --     elseif value.type >= 1000 then
    --         self.FightSystemPanel[key.."_rect"].anchoredPosition = {x = value.posx, y = value.posy}
    --         self.FightSystemPanel[key.."_rect"].localScale = Vec3.New(value.scale,value.scale,value.scale)
    --         self.FightSystemPanel[key.."_canvas"].alpha = value.alpha
	-- 	end
	-- end
end

function FightBtnManager:SaveConfig()
	local jsonStr = self.json.encode(self.BtnConfig)
    PlayerPrefs.SetString("BtnConfig",jsonStr)
end

function FightBtnManager:ReadConfig()
    local jsonStr
    if PlayerPrefs.HasKey("BtnConfig") then 
        jsonStr = PlayerPrefs.GetString("BtnConfig")
        self.BtnConfig = self.json.decode(jsonStr)
    else 
        self.BtnConfig = DefaultConfig
    end
	
    self.type = self.type or self.BtnConfig.ChoseType
    self.BtnDict = self.BtnConfig[tostring(self.type)]
    --self:InitPlane()
end

-- 序列化
function FightBtnManager:CreateJson()
    local math = require('math')
    local string = require("string")
    local table = require("table")

    local json = {} 
    local json_private = {}     

    -- Public constants
    json.EMPTY_ARRAY={}
    json.EMPTY_OBJECT={}

    local decode_scanArray
    local decode_scanComment
    local decode_scanConstant
    local decode_scanNumber
    local decode_scanObject
    local decode_scanString
    local decode_scanWhitespace
    local encodeString
    local isArray
    local isEncodable

    function json.encode (v)
        -- Handle nil values
        if v==nil then
            return "null"
        end

        local vtype = type(v)

        -- Handle strings
        if vtype=='string' then
            return '"' .. json_private.encodeString(v) .. '"'	    -- Need to handle encoding in string
        end

        -- Handle booleans
        if vtype=='number' or vtype=='boolean' then
            return tostring(v)
        end

        -- Handle tables
        if vtype=='table' then
            local rval = {}
            -- Consider arrays separately
            local bArray, maxCount = isArray(v)
            if bArray then
                for i = 1,maxCount do
                    table.insert(rval, json.encode(v[i]))
                end
            else	-- An object, not an array
                for i,j in pairs(v) do
                    if isEncodable(i) and isEncodable(j) then
                        table.insert(rval, '"' .. json_private.encodeString(i) .. '":' .. json.encode(j))
                    end
                end
            end
            if bArray then
                return '[' .. table.concat(rval,',') ..']'
            else
                return '{' .. table.concat(rval,',') .. '}'
            end
        end

        -- Handle null values
        if vtype=='function' and v==json.null then
            return 'null'
        end

        assert(false,'encode attempt to encode unsupported type ' .. vtype .. ':' .. tostring(v))
    end

    function json.decode(s, startPos)
        startPos = startPos and startPos or 1
        startPos = decode_scanWhitespace(s,startPos)
        assert(startPos<=string.len(s), 'Unterminated JSON encoded object found at position in [' .. s .. ']')
        local curChar = string.sub(s,startPos,startPos)
        -- Object
        if curChar=='{' then
            return decode_scanObject(s,startPos)
        end
        -- Array
        if curChar=='[' then
            return decode_scanArray(s,startPos)
        end
        -- Number
        if string.find("+-0123456789.e", curChar, 1, true) then
            return decode_scanNumber(s,startPos)
        end
        -- String
        if curChar==[["]] or curChar==[[']] then
            return decode_scanString(s,startPos)
        end
        if string.sub(s,startPos,startPos+1)=='/*' then
            return json.decode(s, decode_scanComment(s,startPos))
        end
        -- Otherwise, it must be a constant
        return decode_scanConstant(s,startPos)
    end

    function json.null()
        return json.null -- so json.null() will also return null ;-)
    end

    function decode_scanArray(s,startPos)
        local array = {}	-- The return value
        local stringLen = string.len(s)
        assert(string.sub(s,startPos,startPos)=='[','decode_scanArray called but array does not start at position ' .. startPos .. ' in string:\n'..s )
        startPos = startPos + 1
        -- Infinite loop for array elements
        local index = 1
        repeat
            startPos = decode_scanWhitespace(s,startPos)
            assert(startPos<=stringLen,'JSON String ended unexpectedly scanning array.')
            local curChar = string.sub(s,startPos,startPos)
            if (curChar==']') then
                return array, startPos+1
            end
            if (curChar==',') then
                startPos = decode_scanWhitespace(s,startPos+1)
            end
            assert(startPos<=stringLen, 'JSON String ended unexpectedly scanning array.')
            local object
            object, startPos = json.decode(s,startPos)
            array[index] = object
            index = index + 1
        until false
    end

    function decode_scanComment(s, startPos)
        assert( string.sub(s,startPos,startPos+1)=='/*', "decode_scanComment called but comment does not start at position " .. startPos)
        local endPos = string.find(s,'*/',startPos+2)
        assert(endPos~=nil, "Unterminated comment in string at " .. startPos)
        return endPos+2
    end

    function decode_scanConstant(s, startPos)
        local consts = { ["true"] = true, ["false"] = false, ["null"] = nil }
        local constNames = {"true","false","null"}

        for i,k in pairs(constNames) do
            if string.sub(s,startPos, startPos + string.len(k) -1 )==k then
                return consts[k], startPos + string.len(k)
            end
        end
        assert(nil, 'Failed to scan constant from string ' .. s .. ' at starting position ' .. startPos)
    end

    function decode_scanNumber(s,startPos)
        local endPos = startPos+1
        local stringLen = string.len(s)
        local acceptableChars = "+-0123456789.e"
        while (string.find(acceptableChars, string.sub(s,endPos,endPos), 1, true)
        and endPos<=stringLen
        ) do
            endPos = endPos + 1
        end

        local numberValue = string.sub(s, startPos, endPos - 1)
        return tonumber(numberValue), endPos
    end

    function decode_scanObject(s,startPos)
        local object = {}
        local stringLen = string.len(s)
        local key, value
        assert(string.sub(s,startPos,startPos)=='{','decode_scanObject called but object does not start at position ' .. startPos .. ' in string:\n' .. s)
        startPos = startPos + 1
        repeat
            startPos = decode_scanWhitespace(s,startPos)
            assert(startPos<=stringLen, 'JSON string ended unexpectedly while scanning object.')
            local curChar = string.sub(s,startPos,startPos)
            if (curChar=='}') then
                return object,startPos+1
            end
            if (curChar==',') then
                startPos = decode_scanWhitespace(s,startPos+1)
            end
            assert(startPos<=stringLen, 'JSON string ended unexpectedly scanning object.')
            -- Scan the key
            key, startPos = json.decode(s,startPos)
            assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
            startPos = decode_scanWhitespace(s,startPos)
            assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
            assert(string.sub(s,startPos,startPos)==':','JSON object key-value assignment mal-formed at ' .. startPos)
            startPos = decode_scanWhitespace(s,startPos+1)
            assert(startPos<=stringLen, 'JSON string ended unexpectedly searching for value of key ' .. key)
            value, startPos = json.decode(s,startPos)
            object[key]=value
        until false	-- infinite loop while key-value pairs are found
    end

    local escapeSequences = {
        ["\\t"] = "\t",
        ["\\f"] = "\f",
        ["\\r"] = "\r",
        ["\\n"] = "\n",
        ["\\b"] = "\b"
    }
    setmetatable(escapeSequences, {__index = function(t,k)
        -- skip "\" aka strip escape
        return string.sub(k,2)
    end})

    function decode_scanString(s,startPos)
        assert(startPos, 'decode_scanString(..) called without start position')
        local startChar = string.sub(s,startPos,startPos)
        -- START SoniEx2
        -- PS: I don't think single quotes are valid JSON
        assert(startChar == [["]] or startChar == [[']],'decode_scanString called for a non-string')
        --assert(startPos, "String decoding failed: missing closing " .. startChar .. " for string at position " .. oldStart)
        local t = {}
        local i,j = startPos,startPos
        while string.find(s, startChar, j+1) ~= j+1 do
            local oldj = j
            i,j = string.find(s, "\\.", j+1)
            local x,y = string.find(s, startChar, oldj+1)
            if not i or x < i then
                i,j = x,y-1
            end
            table.insert(t, string.sub(s, oldj+1, i-1))
            if string.sub(s, i, j) == "\\u" then
                local a = string.sub(s,j+1,j+4)
                j = j + 4
                local n = tonumber(a, 16)
                assert(n, "String decoding failed: bad Unicode escape " .. a .. " at position " .. i .. " : " .. j)

                local x
                if n < 0x80 then
                    x = string.char(n % 0x80)
                elseif n < 0x800 then
                    -- [110x xxxx] [10xx xxxx]
                    x = string.char(0xC0 + (math.floor(n/64) % 0x20), 0x80 + (n % 0x40))
                else
                    -- [1110 xxxx] [10xx xxxx] [10xx xxxx]
                    x = string.char(0xE0 + (math.floor(n/4096) % 0x10), 0x80 + (math.floor(n/64) % 0x40), 0x80 + (n % 0x40))
                end
                table.insert(t, x)
            else
                table.insert(t, escapeSequences[string.sub(s, i, j)])
            end
        end
        table.insert(t,string.sub(j, j+1))
        assert(string.find(s, startChar, j+1), "String decoding failed: missing closing " .. startChar .. " at position " .. j .. "(for string at position " .. startPos .. ")")
        return table.concat(t,""), j+2
        -- END SoniEx2
    end

    function decode_scanWhitespace(s,startPos)
        local whitespace=" \n\r\t"
        local stringLen = string.len(s)
        while ( string.find(whitespace, string.sub(s,startPos,startPos), 1, true)  and startPos <= stringLen) do
            startPos = startPos + 1
        end
        return startPos
    end


    local escapeList = {
            ['"']  = '\\"',
            ['\\'] = '\\\\',
            ['/']  = '\\/',
            ['\b'] = '\\b',
            ['\f'] = '\\f',
            ['\n'] = '\\n',
            ['\r'] = '\\r',
            ['\t'] = '\\t'
    }

    function json_private.encodeString(s)
    local s = tostring(s)
    return s:gsub(".", function(c) return escapeList[c] end) -- SoniEx2: 5.0 compat
    end

    function isArray(t)
        if (t == json.EMPTY_ARRAY) then return true, 0 end
        if (t == json.EMPTY_OBJECT) then return false end

        local maxIndex = 0
        for k,v in pairs(t) do
            if (type(k)=='number' and math.floor(k)==k and 1<=k) then	-- k,v is an indexed pair
                if (not isEncodable(v)) then return false end	-- All array elements must be encodable
                maxIndex = math.max(maxIndex,k)
            else
                if (k=='n') then
                    if v ~= (t.n or #t) then return false end  -- False if n does not hold the number of elements
                else -- Else of (k=='n')
                    if isEncodable(v) then return false end
                end  -- End of (k~='n')
            end -- End of k,v not an indexed pair
        end  -- End of loop across all pairs
        return true, maxIndex
    end
    function isEncodable(o)
        local t = type(o)
        return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or
            (t=='function' and o==json.null)
    end
    return json
end

