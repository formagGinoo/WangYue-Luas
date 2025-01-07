ActiveAnim = BaseClass("ActiveAnim", AnimBase)

function ActiveAnim:__init(gameObject,toActive)
    self.gameObject = gameObject
    self.toActive = toActive
    self.flag = false
end

function ActiveAnim:Play()
    self.gameObject:SetSmartActive(self.toActive)
    self:BaseComplete()
end

function ActiveAnim.Create(root,animData,nodes,animNodes)
    local gameObject = AnimUtils.GetComponent(root,animData.path).gameObject
    local anim = ActiveAnim.New(gameObject,animData.toActive,animData.time)
    return anim
end