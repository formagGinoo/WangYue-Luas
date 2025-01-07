DebugSkillListPanel = BaseClass("DebugSkillListPanel", BasePanel)

function DebugSkillListPanel:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugSkillList.prefab")
    self.itemObjList = {}
end

function DebugSkillListPanel:__ShowComplete()
    self.canvas.sortingOrder = 9999
    self:UpdateSkillList()

    self.inputField = self:Find("Bg_/InputField", TMP_InputField)
end

function DebugSkillListPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function DebugSkillListPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.CurRoleChange, self:ToFunc("UpdateSkillList"))
    ---监听角色更换
    local dragBehaviour = self.Bg.transform:GetComponent(UIDragBehaviour)
    local onDrag = function(data)
        UnityUtils.SetAnchoredPosition(self.Bg.transform, self.Bg.transform.anchoredPosition.x + data.delta.x * 0.68, self.Bg.transform.anchoredPosition.y + data.delta.y * 0.68)
    end

    self.Change_btn.onClick:AddListener(self:ToFunc("OnClickChange"))
    dragBehaviour.onDrag = onDrag
end

function DebugSkillListPanel:OnClickChange()
    if self.inputField.text and self.inputField.text ~= "" then
        self:UpdateSkillList(tonumber(self.inputField.text))
    end
end

function DebugSkillListPanel:UpdateSkillList(newRoleId)
    for i = 1, #self.itemObjList do
        self.itemObjList[i].object:SetActive(false)
    end
    local index = 1
    self.instanceId = newRoleId or BehaviorFunctions.GetCtrlEntity()
    if not self.instanceId then
        return
    end
    local entity = Fight.Instance.entityManager:GetEntity(self.instanceId)
    if not entity then
        return
    end

    local skillsConfig = entity:GetComponentConfig(FightEnum.ComponentType.Skill).Skills
    --排序
    local skills = {}
    for skillId, _ in pairs(skillsConfig) do
        skills[index] = skillId
        index = index + 1
    end
    table.sort(skills,function(a, b)
        return a < b
    end)
    for i, skillId in pairs(skills) do
        local item = self.itemObjList[i] or self:getItem()
        item.Text_txt.text = skillId
        item.Clone_btn.onClick:RemoveAllListeners()
        item.Clone_btn.onClick:AddListener(function()
            BehaviorFunctions.CastSkillBySelfPosition(self.instanceId, skillId)
        end)
        item.object:SetActive(true)
        self.itemObjList[i] = item
    end

    UnityUtils.SetSizeDelata(self.SkillList.transform, 140, 32 * index + 20)

end

function DebugSkillListPanel:getItem()
    local obj = self:PopUITmpObject("Clone")
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.SkillList.transform)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    return obj
end