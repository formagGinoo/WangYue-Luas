LuaCycleList = LuaCycleList or {}


----------------------------------循环列表公用逻辑
--抽出来做通用逻辑
--item类对应要有个update_my_self(data, i)方法用来设置数据
--setting_data = {
--    item_list --放了 item类对象的列表
--    data_list --数据列表
--    data_head_index  --数据头指针
--    data_tail_index  --数据尾指针
--    item_head_index  --item列表头指针
--    item_tail_index  --item列表尾指针
--    item_con  --item列表的父容器
--    single_item_height --一条item的高度
--    item_con_height --item列表的父容器高度
--    scroll_change_count --父容器滚动累计改变值
--    item_con_last_y --父容器改变时上一次的y坐标
--    scroll_con_height --显示区域的高度
--    set_item_func --更新Item的方法
-- }
function LuaCycleList.refresh_circular_list(setting_data)
    if #setting_data.data_list < #setting_data.item_list then  -- 优化避免无用SetActive
        for i=1,#setting_data.item_list do
            setting_data.item_list[i].gameObject:SetActive(false)
        end
    end

    setting_data.data_head_index = 1
    setting_data.data_tail_index = #setting_data.data_list > #setting_data.item_list and #setting_data.item_list or #setting_data.data_list

    setting_data.item_head_index = 1
    setting_data.item_tail_index = #setting_data.data_list > #setting_data.item_list and #setting_data.item_list or #setting_data.data_list

    if setting_data.data_list == nil then
        setting_data.item_con:GetComponent(RectTransform).sizeDelta = Vector2(0, 0)
        return
    end
    if #setting_data.data_list == 0 then
        setting_data.item_con:GetComponent(RectTransform).sizeDelta = Vector2(0, 0)
    else
        local newH = #setting_data.data_list*setting_data.single_item_height
        setting_data.item_con_height = newH
        setting_data.item_con:GetComponent(RectTransform).sizeDelta = Vector2(0, newH)
    end
    setting_data.item_con:GetComponent(RectTransform).anchoredPosition = Vector2(0, 0)

    for i=1,#setting_data.item_list do
        local newY = (i-1)*-setting_data.single_item_height
        local _X = setting_data.item_list[i].gameObject.transform:GetComponent(RectTransform).anchoredPosition.x
        setting_data.item_list[i].transform:GetComponent(RectTransform).anchoredPosition = Vector2(_X, newY)
    end

    for i=1,#setting_data.data_list do
        if i <= #setting_data.item_list then
            local item = setting_data.item_list[i]
            local data = setting_data.data_list[i]
            setting_data.set_item_func(item, data, i)
            -- item:update_my_self(data, i)
            -- if item.gameObject.activeSelf == false then
                item.gameObject:SetActive(true)
            -- end
        else
            break
        end
    end
end

--(item高度固定)循环列表静态刷新
function LuaCycleList.static_refresh_circular_list(setting_data)
    if #setting_data.data_list < #setting_data.item_list then
        LuaCycleList.refresh_circular_list(setting_data)
    else
        local offset_index = 0
        if setting_data.data_tail_index > #setting_data.data_list then
            offset_index = setting_data.data_tail_index - #setting_data.data_list
            setting_data.data_head_index = setting_data.data_head_index - offset_index
            setting_data.data_tail_index = setting_data.data_tail_index - offset_index
        end

        local data_index= setting_data.data_head_index
        for i=1,#setting_data.item_list do
            local item = setting_data.item_list[i]
            if data_index <= #setting_data.data_list then
                local data = setting_data.data_list[data_index]
                setting_data.set_item_func(item, data, data_index)
                -- item:update_my_self(data, data_index)
                data_index = data_index + 1
            end
        end

        if offset_index ~= 0 then
            for i=1,#setting_data.item_list do
                local item = setting_data.item_list[i]
                local oldY = item.transform:GetComponent(RectTransform).anchoredPosition.y
                local offset_y = offset_index*setting_data.single_item_height
                local newY = oldY + offset_y
                local _X = item.gameObject.transform:GetComponent(RectTransform).anchoredPosition.x
                item.transform:GetComponent(RectTransform).anchoredPosition = Vector2(_X, newY)
            end
        end

        local newH = #setting_data.data_list*setting_data.single_item_height
        setting_data.item_con_height = newH
        setting_data.item_con:GetComponent(RectTransform).sizeDelta = Vector2(0, newH)
    end
end

--scroll滚动监听
function LuaCycleList.on_value_change(setting_data)
    --核心逻辑
    local cur_y = setting_data.item_con:GetComponent(RectTransform).anchoredPosition.y
    setting_data.scroll_change_count = setting_data.scroll_change_count + math.abs(cur_y - setting_data.item_con_last_y)
    if setting_data.scroll_change_count < setting_data.single_item_height then
        setting_data.item_con_last_y = cur_y
        return
    end

    local cross_step = math.floor(setting_data.scroll_change_count/setting_data.single_item_height)
    for i=1,cross_step do
        if cur_y <= setting_data.item_con_last_y then
            if setting_data.data_head_index ~= 1 and cur_y < (setting_data.item_con_height - setting_data.scroll_con_height) then
                local tail_item = setting_data.item_list[setting_data.item_tail_index]
                local oldY = tail_item.transform:GetComponent(RectTransform).anchoredPosition.y
                if math.abs(oldY) > (math.abs(cur_y)+setting_data.scroll_con_height+2*setting_data.single_item_height) then
                    setting_data.data_head_index = setting_data.data_head_index - 1
                    setting_data.data_tail_index = setting_data.data_tail_index - 1
                    local mem_data = setting_data.data_list[setting_data.data_head_index]
                    -- tail_item:update_my_self(mem_data, setting_data.data_head_index)
                    setting_data.set_item_func(tail_item, mem_data, setting_data.data_head_index)
                    local newY = oldY + #setting_data.item_list*setting_data.single_item_height
                    local _X = tail_item.gameObject.transform:GetComponent(RectTransform).anchoredPosition.x
                    tail_item.transform:GetComponent(RectTransform).anchoredPosition = Vector2(_X, newY)
                    setting_data.item_head_index = setting_data.item_tail_index
                    setting_data.item_tail_index = setting_data.item_tail_index - 1
                    if setting_data.item_tail_index <= 0 then
                        setting_data.item_tail_index = #setting_data.item_list
                    end
                end
            end
        elseif cur_y > setting_data.item_con_last_y then
            if setting_data.data_tail_index ~= #setting_data.data_list and cur_y >= setting_data.single_item_height then
                local head_item = setting_data.item_list[setting_data.item_head_index]
                local oldY = head_item.transform:GetComponent(RectTransform).anchoredPosition.y
                if math.abs(oldY) < math.abs(cur_y) - 2*setting_data.single_item_height then
                    setting_data.data_tail_index = setting_data.data_tail_index + 1
                    setting_data.data_head_index = setting_data.data_head_index + 1
                    local mem_data = setting_data.data_list[setting_data.data_tail_index]
                    -- head_item:update_my_self(mem_data, setting_data.data_tail_index)
                    setting_data.set_item_func(head_item, mem_data, setting_data.data_tail_index)
                    local newY = oldY - #setting_data.item_list*setting_data.single_item_height
                    local _X = head_item.gameObject.transform:GetComponent(RectTransform).anchoredPosition.x
                    head_item.transform:GetComponent(RectTransform).anchoredPosition = Vector2(_X, newY)
                    setting_data.item_tail_index = setting_data.item_head_index
                    setting_data.item_head_index = setting_data.item_head_index + 1
                    if setting_data.item_head_index > #setting_data.item_list then
                        setting_data.item_head_index = 1
                    end
                end
            end
        end
        setting_data.scroll_change_count = setting_data.scroll_change_count - setting_data.single_item_height
    end
    setting_data.item_con_last_y = cur_y
end
