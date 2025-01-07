-- ----------------------------------------------------------
-- 公共函数库
-- ----------------------------------------------------------
--import('UnityEngine')
--import('UI')
--import('Events')
--import('Rendering.Universal')
--import('Cinemachine')


--import('Game.Logic')
--import('Game.Asset')

-- 初始化后由ctx.IsDebug值替换，修改debug模式请在base_setting.txt文件中修改
IS_DEBUG = true 

--print = function(...)
    --if IS_DEBUG then
    	--local args = {...}
    	--local new_args = {}
    	--for _, v in ipairs(args) do 
    		--table.insert(new_args, tostring(v))
    	--end
        ---- 打印父节点
        --local track_info = debug.getinfo(2, "Sln")
        --local str = string.format("From %s:%d in function `%s`", track_info.short_src,track_info.currentline,track_info.name or "")

        --Log.Debug(string.format("%s\n%s", table.concat(new_args, " "), str))
    --end
--end
