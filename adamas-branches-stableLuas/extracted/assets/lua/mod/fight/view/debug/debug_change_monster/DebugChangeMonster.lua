DebugChangeMonster = BaseClass("DebugChangeMonster",BasePanel)
function DebugChangeMonster:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugChangeMonster.prefab")
end

function DebugChangeMonster:__CacheObject()
end

function DebugChangeMonster:__BindListener()
    self.ChangeBtn_btn.onClick:AddListener(self:ToFunc("ClickChangeBtn"))
end

function DebugChangeMonster:__Show()
    self:SetCacheMode()
    self.inputFiled = self.NpcInput.transform:GetComponent(TMP_InputField)
    self.inputFiled.text = ""
end

function DebugChangeMonster:ClickChangeBtn()
    local txt = self.inputFiled.text
    if txt == "" then return end
    local newId = tonumber(txt)
    if not newId then return end
    local cb = function ()
        BehaviorFunctions.fight.levelManager:GMChangeBehaviorMonsterId(newId)
    end
    BehaviorFunctions.fight.clientFight.assetsNodeManager:LoadEntity(newId, cb)
end

function DebugChangeMonster:__Hide()

end

function DebugChangeMonster:__delete()

end