DecorationCtrl = BaseClass("DecorationCtrl", Controller)

local _tinsert = table.insert
local _tsort = table.sort
BF = BehaviorFunctions
local DecorationConfig =Config.DataDecorationItem.Find
local DecorationShow = Config.DataDecorationItemshow.Find
local DataDecorationMain = Config.DataDecorationMain.Find
local DataAssetSceneBasic = Config.DataAssetSceneBasic.Find

function DecorationCtrl:__init()
  self.isFirst = true
  self.firstChange = true
  self.decorationSceneConfig = {}
  self.decorationTypeConfig = {}
  self.decorationAllList= {}
  self.decorationBagList = {} 
  self.decorationIdList = {}
  self.decorationCountList = {}
  self.curSceneDecorationList ={}
  self.curDecorationInfo = nil
  self.saveDecorationData = {}
  self.savePosInfo = {}
  self.curRenderObj = nil
  self.bindEntityList = {}
  self.entityList = {}
  self.lastMaerial = nil
end

function DecorationCtrl:InitData(data)
    if self.isFirst then
        self.decorationBagList = data.decoration_list
        for i, v in pairs(DecorationConfig) do
            if not self.decorationSceneConfig[v.asset_id] then
                self.decorationSceneConfig[v.asset_id] ={}
            end
            if not self.decorationSceneConfig[v.asset_id][v.type] then
                self.decorationSceneConfig[v.asset_id][v.type] ={}
            end
            _tinsert(self.decorationSceneConfig[v.asset_id][v.type],v)
        end
        for i,v in pairs(self.decorationBagList) do
            if not self.decorationIdList[v.id] then
                self.decorationIdList[v.id] = v
            end
        end
        self.isFirst = false
    else
        for i,v in pairs(data.decoration_list) do
            self:AddDecoration(v)
        end
        EventMgr.Instance:Fire(EventName.UpdateDecorationInfo)
    end
end

function DecorationCtrl:GetCurSceneConfig()
    
end

function DecorationCtrl:AddDecoration(data)
    _tinsert(self.decorationBagList,data)
    if self.decorationAllList[data.id] then
        --是从场景销毁来的通知场景删除
        self.decorationAllList[data.id].pos_info = ""
        local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
        mod.AssetPurchaseCtrl:DelDecorationBagList(assetId,data)
    else
        self.decorationAllList[data.id] = data
    end
end

function DecorationCtrl:RealAddDecoration(data)
    _tinsert(self.decorationBagList,data)
    EventMgr.Instance:Fire(EventName.UpdateDecorationInfo)
end

function DecorationCtrl:EnterScene(assetId)
    local assetConfig = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(assetId)
    if not assetConfig then
        return
    end
    local list  = assetConfig.decoration_list
    self.curSceneDecorationList = {}
    self.decorationAllList = {}
    for k, v in pairs(list) do
        _tinsert(self.curSceneDecorationList,v)
        self.decorationAllList[v.id] = v
    end
    for i,v in pairs(self.decorationBagList) do
        self.decorationAllList[v.id] = v
    end
    self:InitCreatDecoration()
    self.firstEnterScene = false
end

--初始加载场景物件
function DecorationCtrl:InitCreatDecoration()
    local list = self:GetPlaceDecoration()
    self.decorationController = Fight.Instance.clientFight.decorationManager:GetDecorationController()
    if #list ==0 then
        self.decorationController:InitLoadEntityAssets()
    end
	local countLoad = 0
    for k, v in pairs(list) do
        local config = DecorationConfig[v.template_id]
        if config.type ~= 8 then
            countLoad = countLoad + 1
        end
    end
	
	for k, v in pairs(list) do
		local config = DecorationConfig[v.template_id]
		if config.type == 8 then
			--是材质类型的物件无需摆放到场景中
			self:ChangeMaterial(config)
			self:SetLastMaterial(v)
		else
			self.decorationController:LoadEntityAssets(config.entity_id,v,countLoad)
		end
	end
	
end

function DecorationCtrl:ChangeMaterial(config)

    local mapId = Fight.Instance:GetFightMap()
        local ScenePath = "Scene"..mapId.."_test"
        local sceneObject = GameObject.Find(ScenePath)
        if sceneObject~=nil then
            local DecorationObject = sceneObject:GetComponent("DecorationObjects")
            if DecorationObject then
                if self.firstChange then
                    DecorationObject:Init()
                    self.firstChange = false
                end
               
                DecorationObject:ChangeMaterial(config.material)
            end
        end
end

function DecorationCtrl:GetPlaceDecoration()--获取所有已放置的物件
    local placeList = {}
    for k, v in pairs(self.curSceneDecorationList) do
        if v.pos_info~="" then
            _tinsert(placeList,v)
        else
            for _,v2 in pairs(DataAssetSceneBasic)do
                if v2.device_id == v.template_id  then
                    local pos = v2.coordinate
                    local rot = v2.toward
                    pos = string.gsub(pos,"Vector3","pos")
                    rot = string.gsub(rot,"Vector3","rot")
                    local posInfo = pos.."_"..rot
                    if v.pos_info=="" then
                        v.pos_info = posInfo
                    end
                    _tinsert(placeList,v)
                    self:SendChangeDecoration(v.id,posInfo)
                end
            end
            if v.pos_info == "" then
                self:SendChangeDecoration(v.id,v.pos_info)
            end
        end
    end
    return placeList
end

function DecorationCtrl:UpdateDecorationCountList(data)
    for i,v in pairs(data.decoration_count_list) do
        if not self.decorationCountList[v.key] then
            self.decorationCountList[v.key] = v
        else
            self.decorationCountList[v.key].value = v.value
        end
    end
    EventMgr.Instance:Fire(EventName.UpdateDecorationInfo)
end

function DecorationCtrl:GetSceneDecorationTypeList(assetId)
    --将通用类型添加到当前所选的场景中去
    for k, v in pairs(self.decorationSceneConfig[0]) do
        for _k, config in pairs(v) do
            if not self.decorationSceneConfig[assetId] then
                self.decorationSceneConfig[assetId] = {}
            end
            if not self.decorationSceneConfig[assetId][k] then
                self.decorationSceneConfig[assetId][k] = {}
            end
            for k1, v1 in pairs(self.decorationSceneConfig[assetId][k]) do
                if v1.id == config.id then
                    goto continue
                    break
                end
            end
            _tinsert(self.decorationSceneConfig[assetId][k],config)
            ::continue::
        end
    end 
    return self.decorationSceneConfig[assetId]
end

function DecorationCtrl:GetBagDecorationList()
    return self.decorationBagList
end

function DecorationCtrl:GetDecorationCountList()
    return self.decorationCountList
end

function DecorationCtrl:GetDecorationMain()
    return DataDecorationMain
end

function DecorationCtrl:GetDecorationMainConig(index)
    return DataDecorationMain[index]
end

function DecorationCtrl:AnalyPosInfo(str)

    local pos_str = string.match(str, "pos%((.-)%)")
    local rot_str = string.match(str, "rot%((.-)%)")

    local posstr = {}
    for part in pos_str:gmatch("[^,]+") do
        table.insert(posstr, tonumber(part))
    end
    local rotstr = {}
    for part in rot_str:gmatch("[^,]+") do
        table.insert(rotstr, tonumber(part))
    end
    return posstr,rotstr
end

function DecorationCtrl:GetDecorationConfig(id)
    local config = DecorationConfig[id]
    if config then
        return config
    end
end

function DecorationCtrl:RemoveDecoration(data)
    local config = nil
    local newList = {}
    for i,v in pairs(self.decorationBagList) do
        if v.id ~= data.only_id then
            table.insert(newList, v)
        else
            config = v
        end
    end
    self.decorationBagList = newList
    EventMgr.Instance:Fire(EventName.UpdateDecorationInfo)
    return config
end

function DecorationCtrl:RealRemoveDecoration(data)
    local cfg = nil
    local newList = {}
    for i,v in pairs(self.decorationBagList) do
        if v.id ~= data.id then
            table.insert(newList, v)
        else
            cfg = v
        end
    end
    self.decorationBagList = newList
    if cfg then
        self.decorationAllList[cfg.id] = cfg
    end
    --如果是墙纸类型则保存下
    local config = DecorationConfig[data.template_id]
    if config.decoration_type ==2 then
        if self.lastMaerial then
            --TODO临时处理先加入背包
           self:RealAddDecoration(self.lastMaerial)
           
           self.lastMaerial = data
        else
            self.lastMaerial = data
        end
    end
    EventMgr.Instance:Fire(EventName.UpdateDecorationInfo)
    return cfg
end



function DecorationCtrl:SetLastMaterial(data)
    --将之前的回收
    if self.lastMaerial then
        mod.DecorationCtrl:SendChangeDecoration(self.lastMaerial.id,"")
        self.lastMaerial = data
    else
        self.lastMaerial = data
    end
    
end

function DecorationCtrl:SetCurDecorationInfo(decorationId)
    for i,v in pairs(self.decorationBagList) do
        if v.template_id == decorationId then
            self.curDecorationInfo = v
        end
    end
end

function DecorationCtrl:SetCurDecorationInfoByData(data)
    self.curDecorationInfo = data
end

function DecorationCtrl:ClearCurDecorationInfo()
    self.curDecorationInfo = nil
end

function DecorationCtrl:UpdateSingleDecorationInfo(value)
    for i,v in pairs(self.decorationBagList) do
        if v.id == value.id then
            v.pos_info = value.pos_info
            break
        end
    end
    self.decorationIdList[value.id] = value
end

function DecorationCtrl:ChangeDecorationInfo(value)
    self.decorationAllList[value.id] = value
end

function DecorationCtrl:SetDecorationIcon(templateId)
    local icon,iconDis,name,nameDis= AssetDeviceConfig.GetDecorationItemShow(templateId)

	if icon or name then
		BehaviorFunctions.ShowCharacterHeadTips(self.entity.instanceId, true)
		BehaviorFunctions.ChangeNpcDistanceThreshold(self.entity.instanceId, nil,nil,nameDis ^ 2,iconDis ^2)
		if icon then
			BehaviorFunctions.ChangeNpcHeadIcon(self.entity.instanceId, icon)
		end
		if name then
			BehaviorFunctions.ChangeNpcName(self.entity.instanceId, TI18N(name))
		end

		BehaviorFunctions.SetNonNpcBubbleVisible(9, true)
	end
end

function DecorationCtrl:AddSaveData(data)
    self.saveDecorationData[data.id] = data
    -- _tinsert(self.saveDecorationData,data)
    self:RealRemoveDecoration(data)
end

function DecorationCtrl:CancleSaveData(data)
    if self.saveDecorationData[data.id] then
        self.saveDecorationData[data.id] = nil
    end
end

function DecorationCtrl:RemoveSaveData(data)
    -- local newList = {}
    -- local cfg = nil
    -- for i, v in ipairs(self.saveDecorationData) do
    --     if data.id ~= v.id then
    --         _tinsert(newList,v)
    --     else
    --         cfg = v
    --     end
    -- end
    -- self.saveDecorationData = newList
    local cfg = self.saveDecorationData[data.id]
    self.saveDecorationData[data.id] = nil
    self:RealAddDecoration(cfg)
end

function DecorationCtrl:SavePosInfo(data)
    if data then
        if not self.savePosInfo[data.id] then
            self.savePosInfo[data.id] ={}
        end
        self.savePosInfo[data.id].id = data.id
        self.savePosInfo[data.id].pos_info = data.pos_info
        self.savePosInfo[data.id].template_id = data.template_id
    end
end

function DecorationCtrl:RemovePosInfo(data)
    if data then
        if self.savePosInfo[data.id] then
            self.savePosInfo[data.id] = nil
        end
    end
end


function DecorationCtrl:IsSaveDecoration(id)
    for i,v in pairs(self.saveDecorationData) do
        if v.id == id then
            return false
        end
    end
    return true
end

function DecorationCtrl:OnSaveData()
    for i,v in pairs(self.saveDecorationData) do
        self:SendChangeDecoration(v.id,v.pos_info)
    end
    self.saveDecorationData = {}
    self.savePosInfo = {}
    self.entityList = {}
    EventMgr.Instance:Fire(EventName.UpdateDecorationNumInAsset)
    MsgBoxManager.Instance:ShowTips(TI18N("保存成功"))
end

function DecorationCtrl:OnCancelSaveData()
    for i,v in pairs(self.entityList) do
        self.decorationController:OnQuitControl(i,v)
    end

    for i,v in pairs(self.saveDecorationData) do
        self:RealAddDecoration(v)
    end

    for id, v in pairs(self.savePosInfo) do
        local config = DecorationConfig[v.template_id]
        self.decorationController:LoadEntityAssets(config.entity_id,v,-1)
        self:SendChangeDecoration(v.id,v.pos_info)
        
    end
    self.saveDecorationData = {}
    self.savePosInfo = {}
    self.entityList = {}
end

function DecorationCtrl:OnSaveEntity(data,entity)
    self.entityList[data.id] = entity
end

function DecorationCtrl:OnRemoveEntity(data)
    self.entityList[data.id] = nil
end

function DecorationCtrl:GetDecorationEntity(id)
    return self.entityList[id]
end

function DecorationCtrl:GetSaveList()
    local count = 0 
    for i,v in pairs(self.savePosInfo) do
       count = count + 1
    end
    for i,v in pairs(self.saveDecorationData) do
        count = count + 1
     end
    return count
end

--获取当前背包中的物件的数量
function DecorationCtrl:GetDecorationCount(decorationId)
    local count = 0
    for i,v in pairs(self.decorationBagList) do
        if v.template_id ==decorationId then
            count = count+1
        end
    end
    return count
end

--获取已经拥有的物件数量
function DecorationCtrl:GetrealDecorationCount(decorationId)
    if self.decorationCountList[decorationId] then
        return self.decorationCountList[decorationId].value
    else
        return 0
    end
end

--获取已放置的物件的数量
function DecorationCtrl:GetSetDecorationCount(decorationId)
    local count = 0
    for i,v in pairs(self.decorationAllList) do
        if v.template_id== decorationId and v.pos_info ~="" then
            count= count+1
        end
    end
    return count
end

--绑定放置的实体与物件信息
function DecorationCtrl:BIndEntityAndDecorationInfo(data)
    local entity = self.decorationController.curControlEntity
    self.bindEntityList[entity.instanceId] = data
end

--取消实体的绑定物件回收的时候
function DecorationCtrl:CancelBindEntityInfo(instanceId)
    if self.bindEntityList[instanceId] then
        self.bindEntityList[instanceId] = nil
    end
end

--获取实体信息
function DecorationCtrl:GetEntityDecorationInfo(instanceId)
    return self.bindEntityList[instanceId]
end

--获取实体
function DecorationCtrl:GetEntityByData(data)
    for k,v in pairs(self.bindEntityList)  do
        if data.id == v.id then
            return k
        end
    end
end
--回收时发送的信息
function DecorationCtrl:ReturnDecorationInfo(id)
    local pos_info =""
    mod.DecorationCtrl:SendChangeDecoration(id,pos_info)
end
--打开创建面板
function DecorationCtrl:OpenDecorationPanel()
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:OpenPanel(DecorationMainPanel)
end

function DecorationCtrl:GetDecorationNumAndLimitCount(decorationId)
    local num = self:GetSetDecorationCount(decorationId)
    local config = DecorationConfig[decorationId]
    local LimitCount = -1
    for k, v in pairs(config.building_condition_list) do
        local isOpen, failDesc = Fight.Instance.conditionManager:CheckConditionByConfig(v[1])
        if  isOpen then
            if v[2]>LimitCount then
                LimitCount = v[2]
            end
        end
    end
    return num,LimitCount
end

function DecorationCtrl:SetMeshColliders(gameObject,type)
    local meshColliders = gameObject:GetComponentsInChildren(MeshCollider, true)
    for i = 0, meshColliders.Length - 1 do
        local collider = meshColliders[i]:GetComponent(MeshCollider)
        collider.enabled = type
    end
end

function DecorationCtrl:SendChangeDecoration(id , pos_info)
    local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    mod.DecorationFacade:SendMsg("asset_center_change_decoration_pos",assetId,id,pos_info)
end

function DecorationCtrl:SendBuyDecoration(asset_id,decoration_template_id,amount)
    mod.DecorationFacade:SendMsg("asset_center_buy_decoration",asset_id,decoration_template_id,amount)
end

function DecorationCtrl:__delete()

end