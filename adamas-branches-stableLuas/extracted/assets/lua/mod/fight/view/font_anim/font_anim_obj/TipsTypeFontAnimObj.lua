TipsTypeFontAnimObj = BaseClass("TipsTypeFontAnimObj", FontAnimObj)

local OffsetPos = Vec3.New()
local FightConfig = Config.FightConfig

function TipsTypeFontAnimObj:__init()
    self.path ="Prefabs/UI/Font/tips_type.prefab"
end

function TipsTypeFontAnimObj:__delete()
    if not UtilsBase.IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end
end


function TipsTypeFontAnimObj:OnCache()
    -- self.fight.objectPool:Cache(TipsTypeFontAnimObj, self)
    GameObject.Destroy(self.gameObject)
end

function TipsTypeFontAnimObj:AddTipsMap()
    local map = Fight.Instance.clientFight.fontAnimManager.tipsMap
    local num = 1
    while true do
        if not map[num] then
            Fight.Instance.clientFight.fontAnimManager.tipsMap[num] = true
            return num
        else
            num = num + 1
        end
    end
end

function TipsTypeFontAnimObj:RemoveTipsMap()
    Fight.Instance.clientFight.fontAnimManager.tipsMap[self.num] = nil
end

function TipsTypeFontAnimObj:PlayTipsAnimation(npc, tipsFontType, attachPoint)
    self.num = self:AddTipsMap()
    self.npc = npc
	if not FightConfig then
		return
	end
    local animInfo = FightConfig.TipsFont[tipsFontType]
    local bgName
    if not self.gameObject then
        self:LoadAsset()
        self.gameObjectTrans:SetParent(UIDefine.canvasRoot:GetComponent(RectTransform), false)
        self.animator = self.gameObject:GetComponent(Animator)
    end
    self.animator.enabled = true
    self.canvasGroup.alpha = 1
    self.fontCanvasGroup.alpha = 1
    UtilsUI.SetActive(self.gameObject,false)
    -- AtlasIconLoader.Load(self.fontGameObject.gameObject, "Textures/Icon/Atlas/TipsIcon/" .. animInfo.name .. ".png")
    self.fontTrailGameObject.gameObject:SetActive(true)
    bgName = (animInfo.name == "绝") and "不" or animInfo.name
    AtlasIconLoader.Load(self.fontNessGameObject.gameObject, "Textures/Icon/Atlas/TipsIcon/b_" .. bgName .. ".png",function()
        UtilsUI.SetActive(self.gameObject,true)
        self:PlayAnimatorByName(animInfo.name)
        self.timer = LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("PlayAnimationEnd"))
        LuaTimerManager.Instance:AddTimer(1, 2.9, self:ToFunc("RemoveTipsMap"))
    end)

end

function TipsTypeFontAnimObj:PlayAnimatorByName(name)
    if name == "破" then
        self.animator:Play("tips_type_jipo", 0, 0)
    elseif name == "闪" then
        self.animator:Play("tips_type_shanbi", 0, 0)
    elseif name == "绝" then
        self.animator:Play("tips_type_qijue", 0, 0)
    else
        self.animator:Play("tips_type_buzu", 0, 0)
    end
end

function TipsTypeFontAnimObj:Update()
    -- self:UpdateCyclePos(self.npc)
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    self:UpdateCyclePos(entity) -- 策划说永远在前台角色身上
end

local TempCyclePos = Vec3.New()
local ItmeOffset = Vec3.New(0,50,0)
local Offset = Vec3.New(0,50,0)
function TipsTypeFontAnimObj:GetCyclePos(entity)
	local height = entity.collistionComponent.config.Height
	TempCyclePos:Set(0, height, 0)
	TempCyclePos:Add(entity.transformComponent.position)
 	local sp = UtilsBase.WorldToUIPointBase(TempCyclePos.x, TempCyclePos.y, TempCyclePos.z) 
	return sp + Offset + ItmeOffset * (self.num - 1)
end

function TipsTypeFontAnimObj:UpdateCyclePos(entity)
	local sp = self:GetCyclePos(entity)
	local newSp = Vec3.Lerp(self.gameObjectTrans.transform.localPosition, sp, 0.15)
	UnityUtils.SetLocalPosition(self.gameObjectTrans.transform, newSp.x, newSp.y, 0)
end