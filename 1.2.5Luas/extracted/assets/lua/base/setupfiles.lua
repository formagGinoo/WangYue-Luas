--  require("LuaDebuggee").StartDebug("127.0.0.1", 9826)

--require("LuaPanda").start("127.0.0.1",8818)

require "base/csharp_types"

--非编辑器模式下，直接加载由编译系统产生的文件映射
if not ctx.Editor then
    -- 初始化映射表
    require "clz_mapping_lua"
	require "clz_mapping_data"
else
--编辑器模式下，动态扫描lua目录、配置目录的文件，并建立文件映射
    ClzMapping = {} --类、配置文件映射的文件路径信息
    FileToClass = {} --文件路径所属的类，用于base_class文件中，编辑器状态下检测传入的类名是否正确（编译系统不产生此数据）
    ModuleMapping = {} --所有的模块入口类，用于游戏启动时，自动创建模块
    ClassToModule = {} --类所归属的模块信息
end

-----------------------------------------------------------------------------
Config = Config or {}
local dataG = {}
local __Dataoaded = {}
setmetatable(Config, dataG)
dataG.__index = function(t, k)
    local requireName = ClzMapping[k]
	local loaded = __Dataoaded[requireName]
    if requireName and not loaded then
        __Dataoaded[requireName] = true
        if require (ClzMapping[k]) then
            return Config[k]
        else
            return false
        end
    end
end

local parentG = {}
local __ModuleLoaded = {}
setmetatable(_G, parentG)
parentG.__index = function(t, k)
    local requireName = ClzMapping[k]
	local loaded = __ModuleLoaded[requireName]
    if requireName and not loaded then
        __ModuleLoaded[requireName] = true
        if require (ClzMapping[k]) then
            return _G[k]
        else
            return false
        end
    else
        local loadType = GetCSharp(k)
        if loadType then
            _G[k] = loadType
            return loadType
        end
    end
end

function clear_loaded_files()
	__ModuleLoaded = {}
	__Dataoaded = {}
end
-----------------------------------------------------------------------

require "util/log"


if ctx.Editor then
    local ClassToFile = {}
    local fileNames = {}

    local luaPath = IOUtils.GetAbsPath(Application.dataPath .. "/../../lua/")
    local dataPath = IOUtils.GetAbsPath(Application.dataPath .. "/../../data/lua")

    local nameRx = "^[a-zA-Z][a-zA-Z_0-9]*$"
    local folderRx = "^[a-z][a-z0-9_]*$"
    local numRx = "^[0-9]*$"

    Log("lua路径:"..luaPath)
    Log("data路径:"..dataPath)

    function ParseLuaFile(file)
        local filePath = IOUtils.SubPath(file,luaPath)

        local fileName = IOUtils.GetFileName(file)

        if not string.match(fileName,nameRx)
            or string.sub(fileName, -1) == "_" 
            or string.find(fileName, "__") then
            LogErrorf("lua文件命名异常[%s]（只能出现字母、数字、下划线，首尾不能为下划线，不能出现连续2个下划线 ）",filePath)
            return
        end
		if fileNames[fileName] then
			LogError(string.format("lua文件存在相同命名[%s][%s]",fileNames[fileName],filePath))
		end
        --assert(not fileNames[fileName],string.format("lua文件存在相同命名[%s][%s]",fileNames[fileName],filePath))
        fileNames[fileName] = filePath

        --首字母非大写
        local firstChar = string.byte(fileName,1)
        if firstChar < string.byte("A") or firstChar > string.byte("Z") then
            return
        end

        local className = fileName

        local excludeExtFilePath = IOUtils.GetPathExcludeExt(filePath,false)
        ClzMapping[className] = excludeExtFilePath
        ClassToFile[className] = excludeExtFilePath

        local moduleLocalPath = IOUtils.SubPath(filePath,"mod/")
        if filePath == moduleLocalPath then return end

        local index =  string.find(moduleLocalPath,"/")
        if index == nil then return end

        local moduleFacadeName = ""
        local moduleName = string.sub(moduleLocalPath, 1, index-1)
        for str in string.gmatch(moduleName,"([^_]+)") do
            local cell = string.sub(string.upper(str),1,1) ..string.sub(str,2)
            moduleFacadeName = moduleFacadeName ..cell
        end
        moduleFacadeName = moduleFacadeName.."Facade"

        local num = ModuleMapping[moduleFacadeName] or 0
        ModuleMapping[moduleFacadeName] = num + 1
        ClassToModule[className] = moduleFacadeName
    end

    function ParseDataFile(file)
        local fileName = IOUtils.GetFileName(file)
        local configName = ""
        for str in string.gmatch(fileName,"([^_]+)") do
            local cell = string.sub(string.upper(str),1,1) ..string.sub(str,2)
            configName = configName ..cell
        end

        local filePath = IOUtils.SubPath(file,dataPath)
        local excludeExtFilePath = IOUtils.GetPathExcludeExt(filePath,false)
        ClzMapping[configName] = "data/" .. excludeExtFilePath
    end

    local files = IOUtils.GetFiles(luaPath,"lua")
    for i=0,files.Length-1 do ParseLuaFile(files[i]) end
        
    local files = IOUtils.GetFiles(dataPath,"lua")
    for i=0,files.Length-1 do ParseDataFile(files[i]) end

    for k,v in pairs(ClassToFile) do
        FileToClass[v] = k
    end
end 


require "base/common"
require "base/class/BaseClass"
require "base/class/SingleClass"
require "base/class/StaticClass"
require "util/I18N"
require "util/utils_enum"

List = require "common/container/list"

--ui扩展
require "base/ui/ext/ext_Component"
require "base/ui/ext/ext_Transform"
require "base/ui/ext/ext_GameObject"
require "base/ui/ext/ext_Button"
require "base/ui/ext/ext_EventTrigger"
require "base/ui/ext/ext_RectTransform"
require "base/ui/ext/ext_Image"
require "base/ui/ext/ext_Toggle"
require "base/ui/ext/ext_Slider"

-- 放在最后
--if not ctx.Editor then
    require "base/lua_preload"
--end

--require "base/lua_global_setting"
