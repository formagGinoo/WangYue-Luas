BargainAnimState = BaseClass("BargainAnimState", Module)

local _tinsert = table.insert
local _tremove = table.remove

function BargainAnimState:__init(modelView, modelEnum)
    self.modelView = modelView
    self.modelEnum = modelEnum
end

function BargainAnimState:__delete()
    if self.nextTimer then
        LuaTimerManager.Instance:RemoveTimer(self.nextTimer)
        self.nextTimer = nil
    end
end

function BargainAnimState:LoadAnim(anims)
    self.index = 1
    self.anims = anims
    if self.nextTimer then
        LuaTimerManager.Instance:RemoveTimer(self.nextTimer)
        self.nextTimer = nil
    end
    self:PlayAnim()
end

function BargainAnimState:PlayAnim()
    if self.index > #self.anims then
        return
    end

    local animLength = nil
    if self.modelEnum == BargainEnum.Model.Player then
        self.modelView:PlayModelAnimLayerName("PlayerRoot", self.anims[self.index], "Perform Layer")
        animLength = mod.BargainCtrl:GetPlayerAnimationClipLength(self.anims[self.index])
    elseif self.modelEnum == BargainEnum.Model.Npc then
        self.modelView:PlayModelAnimLayerName("NpcRoot", self.anims[self.index], "Perform Layer")
        animLength = mod.BargainCtrl:GetNpcAnimationClipLength(self.anims[self.index])
    end

    if animLength ~= nil then
        self.nextTimer = LuaTimerManager.Instance:AddTimer(1, animLength, function ()
            self.index = self.index + 1
            LuaTimerManager.Instance:RemoveTimer(self.nextTimer)
            self.nextTimer = nil
            self:PlayAnim()
        end)
    end
end

--[[
    {
        [] = {
            layer = "",
            anims = {"", ""}
        },
        [] = ...,
        mainAnim = 1,
        mainAnimCount,
        delay = {},
    }
]]
function BargainAnimState.CreateParam(param)
    return {}
end
function BargainAnimState.ParamAddAnims(param, layer, anims)
    _tinsert(param, {layer = layer, anims = anims})
    return param
end
function BargainAnimState.SetMainAnim(param, index)
    param.mainAnim = index
    param.mainAnimCount = #param[index].anims
    return param
end
function BargainAnimState.GetParamAnimStateLength(param)
    return #param
end
function BargainAnimState.SetPlayerParam(param, animKey)
    local animInfo = BargainConfig.GetDialogAnim(animKey)
    BargainAnimState.ParamAddAnims(param, "Perform Layer", animInfo.perfrom_layer)
    BargainAnimState.ParamAddAnims(param, "Face Layer", animInfo.face_layer)
    BargainAnimState.ParamAddAnims(param, "Lip Layer", animInfo.lip_layer)
    BargainAnimState.SetMainAnim(param, 1)
    return param
end
function BargainAnimState.SetLayerDelay(param, layerName, delaySecond, defaultAnimName)
    if not param.delay then
        param.delay = {}
    end
    param.delay[layerName] = {delaySecond = delaySecond, defaultAnimName = defaultAnimName}
    return param
end

function BargainAnimState:LoadAnimV2(param)
    if BargainAnimState.GetParamAnimStateLength(param) < 1 then
        LogError("[砍价玩法]动画错误!")
        return
    end
    self.index = 1
    self.param = param
    if not self.param.mainAnim then
        self.param.mainAnim = 1
    end
    if self.nextTimer then
        LuaTimerManager.Instance:RemoveTimer(self.nextTimer)
        self.nextTimer = nil
    end

    if self.delayAnimStates then
        for k, v in ipairs(self.delayAnimStates) do
            if v.timer then
                LuaTimerManager.Instance:RemoveTimer(v.timer)
                v.timer = nil
            end
            v.animState:DeleteMe()
        end
        self.delayAnimStates = nil
    end

    if self.param.delay then
        self.delayAnimStates = {}
        for layerName, delayInfo in pairs(self.param.delay) do
            local delayAnimParam = BargainAnimState.CreateParam()
            for index, animInfo in pairs(self.param) do
                if animInfo.layer == layerName then
                    BargainAnimState.ParamAddAnims(delayAnimParam, animInfo.layer, animInfo.anims)
                    BargainAnimState.SetMainAnim(delayAnimParam, 1)
                    _tremove(self.param, index)
                    break
                end
            end
            _tinsert(self.delayAnimStates, {animState = BargainAnimState.New(self.modelView, self.modelEnum), param = delayAnimParam, delayTime = delayInfo.delaySecond})
            if self.modelEnum == BargainEnum.Model.Player then
                self.modelView:PlayModelAnimLayerName("PlayerRoot", delayInfo.defaultAnimName, layerName)
            elseif self.modelEnum == BargainEnum.Model.Npc then
                self.modelView:PlayModelAnimLayerName("NpcRoot", delayInfo.defaultAnimName, layerName)
            end
        end

        for i, v in ipairs(self.delayAnimStates) do
            local delayAnimState = v
            delayAnimState.timer = LuaTimerManager.Instance:AddTimer(1, delayAnimState.delayTime, function ()
                delayAnimState.timer = nil
                delayAnimState.animState:LoadAnimV2(delayAnimState.param)
            end)
        end
    end

    self:PlayAnimV2()
end

function BargainAnimState:PlayAnimV2()
    if self.index > self.param.mainAnimCount then
        return
    end

    local animLength = nil
    if self.modelEnum == BargainEnum.Model.Player then
        for _, v in ipairs(self.param) do
            self.modelView:PlayModelAnimLayerName("PlayerRoot", v.anims[self.index], v.layer)
        end
        animLength = mod.BargainCtrl:GetPlayerAnimationClipLength(self.param[self.param.mainAnim].anims[self.index])
    elseif self.modelEnum == BargainEnum.Model.Npc then
        for _, v in ipairs(self.param) do
            self.modelView:PlayModelAnimLayerName("NpcRoot", v.anims[self.index], v.layer)
        end
        animLength = mod.BargainCtrl:GetNpcAnimationClipLength(self.param[self.param.mainAnim].anims[self.index])
    end

    if animLength ~= nil then
        self.nextTimer = LuaTimerManager.Instance:AddTimer(1, animLength, function ()
            self.index = self.index + 1
            LuaTimerManager.Instance:RemoveTimer(self.nextTimer)
            self.nextTimer = nil
            self:PlayAnimV2()
        end)
    end
end