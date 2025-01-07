---@class StoryCtrl : Controller
StoryCtrl = BaseClass("StoryCtrl", Controller)

function StoryCtrl:__init()
    self.SelectDialogMap = nil
end

function StoryCtrl:__delete()
    
end

function StoryCtrl:__InitComplete()

end

function StoryCtrl:UpdataoSelectDialog(data)
    if not self.SelectDialogMap then
        self.SelectDialogMap = data
    else
        for k, v in pairs(data) do
            self.SelectDialogMap[k] = v
        end
    end
end

function StoryCtrl:RemoveSelectDialog(type)
    for k, v in pairs(self.SelectDialogMap) do
        if StoryConfig.GetDialogRewardType(v) == type then
            self.SelectDialogMap[k] = nil
        end
    end
end

function StoryCtrl:GetSaveDialog(id)
    return self.SelectDialogMap[id]
end

function StoryCtrl:SelectDialog(storyId,selectId)
    if StoryConfig.CheckReward(selectId) then
        CurtainManager.Instance:EnterWait()
        local id, cmd = mod.StoryFacade:SendMsg("dialog_select",selectId)
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
            CurtainManager.Instance:ExitWait()
        end)
    end
end