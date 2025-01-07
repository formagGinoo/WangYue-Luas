
-- lua内存泄露检查工具
--  作者：黄泽枫  --
-- 时间18-1-30 --
-- 原理：在BaseClass的New方法中将创建出来的对象保存到一个全局的弱引用表ClassTable中,
-- 再根据对象中的.DeleteMe方法是否存在判断对象是否已经调用DeleteMe销毁了，正常情况下
-- 调用了DeleteMe的对象在lua进行回收过后应该不存在于弱引用表ClassTable中，如果存在，说明
-- 这个对象在某个地方被引用了，无法回收，通过遍历G表和注册表debug.getregistry() 里面的table
-- 和function的Upvalue将所有引用的地方打印出来即可知道是哪些地方引用的导致无法回收。
-- ====================================================================
-- 特殊情况：如果查找结构中出现了注册表的方法的upvalue的引用这种情况很有可能是类被C#那边的回调函数
-- 所引用，例如：table: 0x12a0897d0 = "reg/function: 0x14f253ae0(function upvalue)(self)",
-- 这个的解决方法就是在该回调执行完之后置空该回调，一般UGUI中的按钮点击等事件回调不会出现这种问题，
-- LeanTween的回调会出现这个问题，处理方法是修改leantween的代码LeanTween.update()方法中
--             for(int i = 0; i < finishedCnt; i++){
--                 j = tweensFinished[i];
--                 tween = tweens[ j ];
--                 removeTween(j);
--                 if(tween.hasExtraOnCompletes)
--                     tween.callOnCompletes();
--                 tween.optional.reset ();  // 这里加上这句直接清空所有回调
--             }
-- ===========================使用示例=======================
            -- local num = 0
            -- print("ClassTable地址为：\n"..tostring(ClassTable))
            -- for k,v in pairs(ClassTable) do
            --     if k ~= nil and k.DeleteMe == nil then
            --         print(tostring(k), k.traceinfo)
            --         debug.GetRef(k)
            --         num = num + 1
            --         -- if num > 5 then
            --         --     return
            --         -- end
            --     end
            -- end



-- 递归引用查找方法
--
function debug.count_ref(currname, currtab, targetobj, his, result)
    local currmt = debug.getmetatable(currtab)
    if currmt ~= nil and his[currmt] == nil then
        his[currmt] = true
        debug.count_ref(currname..tostring(k).."[mt]/", currmt, targetobj, his, result)
        if currmt == targetobj then
            result[currname..tostring(k)] = string.format("%s/%s[mt](%s)", currname, tostring(k), tostring(currmt))
        end
    end
    for k,v in pairs(currtab) do
        if v == targetobj then
            result[currtab] = currname
            -- table.insert(result, currname)
        end
        if k == targetobj then
            result[currtab] = currname
        end
        if type(v) == "table" and his[v] == nil then
            his[v] = true
            debug.count_ref(currname..tostring(k).."/", v, targetobj, his, result)
            local mt = debug.getmetatable(v)
            if mt ~= nil and his[mt] == nil then
                his[mt] = true
                debug.count_ref(currname..tostring(k).."[mt]/", mt, targetobj, his, result)
                if mt == targetobj then
                    result[currname..tostring(k)] = string.format("%s/%s[mt](%s)", currname, tostring(k), tostring(mt))
                end
            end
        end
        if type(k) == "table" and his[k] == nil then
            his[k] = true
            debug.count_ref(currname.."[key]".."/", k, targetobj, his, result)
            local mt = debug.getmetatable(k)
            if mt ~= nil and his[mt] == nil then
                his[mt] = true
                debug.count_ref(currname.."[key][mt]".."/", mt, targetobj, his, result)
                if mt == targetobj then
                    result[currname..tostring(k)] = string.format("%s/%s[key][mt](%s)", currname, tostring(k), tostring(mt))
                end
            end
        end
        if type(v) == "function" and his[v] == nil then
            local i = 1
            his[v] = true
            while true do
               local n, upv = debug.getupvalue(v, i)
               if not n then break end
               if type(upv) == "table" and his[upv] == nil then
                    his[upv] = true
                    debug.count_ref(string.format("%s/%s(upvalue)(%s)", currname, tostring(v), tostring(n)), upv, targetobj, his, result)
                    local mt = debug.getmetatable(upv)
                    if mt ~= nil and his[mt] == nil then
                        his[mt] = true
                        debug.count_ref(currname..tostring(k).."/", mt, targetobj, his, result)
                    end
                elseif upv == targetobj then
                    result[currtab] = string.format("%s/%s(function upvalue)(%s)", currname, tostring(v), tostring(n))
                end
               i = i + 1
            end
        end
    end
end

function debug.GetRef(obj)
    if obj ~= nil then
        local rectable = {}
        local result = {}
        setmetatable(rectable, {__mode = "kv"})
        setmetatable(result, {__mode = "kv"})
        local g = _G
        local reg = debug.getregistry()
        debug.count_ref("", g, obj, rectable, result)
        debug.count_ref("reg", reg, obj, rectable, result)
        UtilsBase.dump(result, "结果")
        -- LocalizeManager.Instance:SaveData("GGG.lua", result)
    else
        UtilsBase.dump("空对象")
    end
end