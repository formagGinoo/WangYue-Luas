CustomDataBlackBoard = BaseClass("CustomDataBlackBoard")

function CustomDataBlackBoard:__init()
    CustomDataBlackBoard.Instance = self
    self.blackboard = {}
    self.dataHandler = {}
end

--新增数据
function CustomDataBlackBoard:AddDataBlackBoard(key, value)
    if not key then
        LogError("没有填写Event")
        return
    end

    if not self.dataHandler[key] then
        self.dataHandler[key] = {}
    end
    self.blackboard[key] = value
end

--修改数据
function CustomDataBlackBoard:ChangeBlackBoardData(key, value)
    if not self.dataHandler[key] then
        self.dataHandler[key] = {}
    end
    if self.blackboard[key] == value then
        return
    end

    self.blackboard[key] = value
    ---直接调FSMBehavior的函数
    --Fight.Instance.entityManager:CallBehaviorFun("BlackBoard_Change_" .. key, value)

    ---回调
    --local call = function()
        for _, func in pairs(self.dataHandler[key]) do
            func(value)
        end
    --end
    --
    --local status, err = xpcall(call, function(errinfo)
    --
    --end, ...)

end

--读取数据
function CustomDataBlackBoard:GetDataValue(key)
    return self.blackboard[key]
end

--注册对数据的监听
function CustomDataBlackBoard:AddListener(key, handler)
    if not self.dataHandler[key] then
        self.dataHandler[key] = {}
    end
    self.dataHandler[key][handler] = handler
end

--取消对数据监听
function CustomDataBlackBoard:RemoveListener(key, handler)
    if self.dataHandler[key] then
        self.dataHandler[key][handler] = nil
    end
end
function CustomDataBlackBoard:RemoveAllListener(key)
    if self.dataHandler[key] then
        TableUtils.ClearTable(self.dataHandler[key])
    end
end