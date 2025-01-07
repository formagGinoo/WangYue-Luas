StringHelper = BaseClass("StringHelper")

-- trim掉开头和末尾的空格
function StringHelper.Trim(str)
    return str:match("^%s*(.-)%s*$")
end

function StringHelper.Split(target_str, spliter)
    if target_str and spliter then
        local result = {}

        for item in (target_str .. spliter):gmatch("(.-)" .. spliter) do
            table.insert(result, item)
        end

        return result
    end
end

function StringHelper.GetRepeatStr(target_str, count)
    if target_str and count then
        local result = ""
        for index = 1, count do
            result = result .. target_str
        end
        return result
    end
end

function StringHelper.ConcatTable(target_table)
    if not target_table then
        print("[StringHelper.ConcatTable]: target_table is nil.")
        return
    end

    local result = ""
    for index = 1, #target_table do
        result = result .. target_table[index]
    end
    return result
end

--返回字符串内容中，符合 两个符号中间有内容的格式的列表
function StringHelper.MatchBetweenSymbols(str, s1, s2)
    local m = {}
    local parten = string.format("%s(.-)%s", s1, s2)
    for a in string.gmatch(str, parten) do
        table.insert(m, a)
    end
    return m
end

----解析字符串 把带 {n} 转换为对应参数
function StringHelper.ReplaceConfigStr(str, ...)
    local num_args = select("#", ...)
    for i = 1, num_args do
        local arg = select(i, ...)
        if arg == nil then arg = "" end
        str = string.gsub(str, string.format("{%s}", i), arg, 1)
    end
    return str
end

-- 取到带颜色标签的字符串列表
function StringHelper.GetColorString(str)
    local back = {}
    local parten = "(<color.-</color>)"
    for result in string.gmatch(str, parten) do
        table.insert(back, result)
    end
    return back
end

function StringHelper.GetColorAndString(str)
    local back = {}
    local parten = "<color='(.-)'>(.+)</color>"
    for color,str in string.gmatch(str, parten) do
        table.insert(back, {color = color, str = str})
    end
    return back
end

-- 返回按字符串一个个字符分开的列表
function StringHelper.ConvertStringTable(str)

    -- 取到带颜色的字符串,这串东西做一次显示
    local colors = StringHelper.GetColorString(str)

    -- 保存已开始位置为Key，结束位置为值
    local colorTab = {}
    for _,colorStr in ipairs(colors) do
        local startVal,endVal = string.find(str, colorStr)
        if startVal then
            colorTab[startVal] = endVal
        end
    end

    local back = {}
    local len = string.len(str)
    local current = 1
    local count = 0
    while current <= len do
        if colorTab[current] ~= nil then
            local one = string.sub(str, current, colorTab[current])
            table.insert(back, one)
            current = colorTab[current] + 1
        else
            local byteCount = string.byte(str, current)
            if byteCount == 194 then
                count = count + 1
                if count == 2 then
                    local one = string.sub(str, current, current + count - 1)
                    table.insert(back, one)
                    current = current + count
                    count = 0
                end
            elseif byteCount > 127 then
                count = count + 1
                if count == 3 then
                    local one = string.sub(str, current, current + count - 1)
                    table.insert(back, one)
                    current = current + count
                    count = 0
                end
            else
                local one = string.sub(str, current, current)
                table.insert(back, one)
                current = current + 1
            end
        end
    end
    return back
end

function StringHelper.LimitChineseNum(str, limitNum)
    local result = string.Empty
    if limitNum <= 0 then
        return result
    end
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local size = StringHelper.GetCharSize(char)
        if size > 1 then
            len = len + 1   --卓洛要求把中文当一个字符
        else
            len = len + 1
        end
        result = result .. string.sub(str, currentIndex, currentIndex + size - 1)
        currentIndex = currentIndex + size
        if len >= limitNum then
            break
        end
    end
    return result, len
end

function StringHelper.GetChineseLength(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local size = StringHelper.GetCharSize(char)
        if size > 1 then
            len = len + 1
        else
            len = len + 1
        end
        currentIndex = currentIndex + size
    end
    return len
end

function StringHelper.GetLineByLength(str)
    local count = StringHelper.GetChineseLength(str)
    local line = ""
    for i=1,count-1 do
        line = string.format(_T("%s_"), line)
    end
    return line
end

function StringHelper.GetCharSize(char)
    if not char then
        return 0
    elseif char >= 240 then
        return 4
    elseif char >= 224 then
        return 3
    elseif char >= 192 then
        return 2
    else
        return 1
    end
end

-- 过滤emoji
function StringHelper.FilterEmoji(str)
    local res = ""
    for utfChar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do  
        local tmp = utfChar
        if string.isEmoji(utfChar) then
            tmp = " "  -- 替换为空格
        end
        res = res .. tmp
    end
    return res
end

function StringHelper.AllCharacterCanShow(str)
    local magic = HeadElementCanvas.Instance.magicText
    magic.text = ""
    local list = StringHelper.ConvertStringTable(str)
    local preferredWidth = 0
    local lastWidth = 0
    for i = 1, #list do
        magic.text = magic.text .. list[i]
        if magic.preferredWidth == lastWidth then
            return false
        else
            lastWidth = magic.preferredWidth
        end
    end
    return true
end

function StringHelper.Sub(str, startIndex, endIndex)
    local tempStr = str 
    local byteStart = 1 -- string.sub截取的开始位置
    local byteEnd = -1 -- string.sub截取的结束位置
    local index = 0  -- 字符记数
    local bytes = 0  -- 字符的字节记数

    startIndex = math.max(startIndex, 1)
    endIndex = endIndex or -1
    while string.len(tempStr) > 0 do     
        if index == startIndex - 1 then
            byteStart = bytes + 1
        elseif index == endIndex then
            byteEnd = bytes
            break
        end
        bytes = bytes + StringHelper.GetCharSize(string.byte(tempStr, 1))
        tempStr = string.sub(str, bytes + 1)

        index = index + 1
    end
    return string.sub(str, byteStart, byteEnd)
end

function StringHelper.NaturalToChineseStr(num)
    if num == 1 then
        return _T("一")
    elseif num == 2 then
        return _T("二")
    elseif num == 3 then
        return _T("三")
    elseif num == 4 then
        return _T("四")
    elseif num == 5 then
        return _T("五")
    elseif num == 6 then
        return _T("六")
    elseif num == 7 then
        return _T("七")
    elseif num == 8 then
        return _T("八")
    elseif num == 9 then
        return _T("九")
    elseif num == 10 then
        return _T("十")
    end
end

function StringHelper.ApplyText(inStr)
    local lastIndex = 0
    local nowType = 0
    local littleIndex = 0
    local textIndex = 0
    local isNew = false
    local title
    local textList = {}
    for i=1,#inStr do
        local str = string.sub(inStr,i,i+1)
        if str == "|[" or str == "|<" or str == "|(" then
            lastIndex = i + 2
            isNew = true

        elseif str == "]|" or str == ">|" or str == ")|" then
            local str2 = string.sub(inStr,lastIndex,i-1)
            if str == "]|" then
                title = str2
            elseif str == ">|" or str == ")|" then
                table.insert(textList, str2)
            end
        end
    end
    return textList, title
end

function StringHelper.SplitParam(string,sep)
    local list = {}
    if string == nil then
        return nil
    end
    string.gsub(string,'[^'..sep..']+',function (w)
            table.insert(list,w)
        end)
    return list
end