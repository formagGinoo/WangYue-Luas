GameTimePanel = BaseClass("GameTimePanel", BasePanel)

local function calculateIntersection(x0, y0, x, y, r)
    -- 计算射线OA的方向向量
    local dx = x - x0
    local dy = y - y0

    -- 计算射线OA的长度
    local lengthOA = math.sqrt(dx * dx + dy * dy)

    -- 计算射线与圆的交点坐标
    local intersectionX = x0 + (dx / lengthOA) * r
    local intersectionY = y0 + (dy / lengthOA) * r

    return intersectionX, intersectionY
end

local function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance
end

local function rotatePoint(x, y, a)
    -- 将角度转换为弧度
    local radians = math.rad(a)

    -- 计算旋转后的坐标
    local rotatedX = x * math.cos(radians) - y * math.sin(radians)
    local rotatedY = x * math.sin(radians) + y * math.cos(radians)

    return rotatedX, rotatedY
end

local function calculateRotationAngle(OAx, OAy, OBx, OBy)
    -- 计算向量 OA 的长度和角度
    local lengthOA = math.sqrt(OAx * OAx + OAy * OAy)
    local angleOA = math.deg(math.atan(OAy, OAx))

    -- 计算向量 OB 的长度和角度
    local lengthOB = math.sqrt(OBx * OBx + OBy * OBy)
    local angleOB = math.deg(math.atan(OBy, OBx))

    -- 计算旋转角度
    local angle = angleOA - angleOB

    -- 范围调整
    if angle < 0 then
        angle = angle + 360
    end

    return angle
end

function GameTimePanel:__init()
    self:SetAsset("Prefabs/UI/DayNight/GameTimePanel.prefab")
end

function GameTimePanel:__BindListener()
    self.BackBtn_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnSubmit"))
    self.TargetPoint_drag.onDrag = self:ToFunc("OnDrag")
    self.TargetPoint_drag.onPointerEnter = self:ToFunc("OnPointerEnter")
    self.TargetPoint_drag.onPointerExit = self:ToFunc("OnPointerExit")
end

function GameTimePanel:__AfterExitAnim()
    self.parentWindow:ReturnMenu()
end

local UnitAngle = -360
function GameTimePanel:__Show()
    self.inDragArea = false
    local x1 = self.TargetCenter_rect.localPosition.x
    local y1 = self.TargetCenter_rect.localPosition.y
    local x2 = self.CurPoint_rect.localPosition.x
    local y2 = self.CurPoint_rect.localPosition.y
    self.Ox = x1
    self.Oy = y1
    self.radius = calculateDistance(x1, y1, x2, y2)
    self:ShowDetail()
end

function GameTimePanel:CalculateIntersection(targetX, targetY)
    return calculateIntersection(self.Ox, self.Oy, targetX, targetY, self.radius)
end

function GameTimePanel:ShowDetail()
    local total, curTime = DayNightMgr.Instance:GetTime()
    self.curTime = curTime
    self.addTime = 0
    self.lastAddTime = 0

    self.maxClockTime = 24 * 60
    self.maxAddTime = 24 * 60
    self.changeValue = 0
    local hour = math.floor(curTime / 60)
    local minute = math.fmod(curTime, 60)
    self.CurTime_txt.text = string.format("%02d:%02d", hour, minute)
    self.ChangeTimePart:SetActive(false)
    
    local targetZ = self.curTime / self.maxClockTime * UnitAngle
    self.startX, self.startY = rotatePoint(0, - 1000, targetZ)
    UnityUtils.SetLocalEulerAngles(self.Progress_rect, 0, 0, targetZ)
    self:UpdateTargetTime()
end

function GameTimePanel:UpdateTargetTime()
    local targetTime = self.curTime + self.addTime
    if self.addTime == 0 then
        self.NotChangeBtn:SetActive(true)
        self.Submit:SetActive(false)
        self.ChangeTimePart:SetActive(false)
        local hour = math.floor(self.curTime / 60)
        local minute = math.fmod(self.curTime, 60)
        self.CurTime_txt.text = string.format("%02d:%02d", hour, minute)
    else
        self.NotChangeBtn:SetActive(false)
        self.Submit:SetActive(true)
        self.ChangeTimePart:SetActive(true)
        local hour = math.floor(self.curTime / 60)
        local minute = math.fmod(self.curTime, 60)
        self.TargetTime_txt.text = string.format("%02d:%02d", hour, minute)

        hour = math.floor(targetTime / 60)
        minute = math.floor(math.fmod(targetTime, 60))
        self.CurTime_txt.text = string.format("%02d:%02d", math.fmod(hour, 24), minute)
        self.NextDay:SetActive(targetTime > self.maxClockTime)
    end
    local targetZ = targetTime / self.maxClockTime * UnitAngle
    local tx, ty = rotatePoint(0, -1000, targetZ)
    local x, y = self:CalculateIntersection(tx, ty)
    UnityUtils.SetLocalPosition(self.TargetPoint_rect, x, y, 0)

    local value = self.addTime / self.maxClockTime
    self.Progress_img.fillAmount = value
end

function GameTimePanel:OnDrag(data)
    local uiCamera = ctx.UICamera
    local spPoint = uiCamera:WorldToScreenPoint(self.TargetCenter_rect.position)
    local pos = {}
    pos.x = data.position.x - spPoint.x
    pos.y = data.position.y - spPoint.y

    local res = calculateRotationAngle(self.startX, self.startY, pos.x, pos.y)
    local value = res / 360 * self.maxClockTime
    local old = self.addTime
    self.addTime = math.floor(value)

    local res = math.abs(old - self.addTime)
    if res > self.maxClockTime / 2  then
        if self.addTime > old  then
            self.addTime = 0
        else
            self.addTime = self.maxClockTime
        end
    end
    if self.addTime < 0 then
        self.addTime = 0
    elseif self.addTime > self.maxAddTime then
        self.addTime = self.maxAddTime
    end
    self:UpdateTargetTime()
end

function GameTimePanel:OnPointerEnter()
    self.inDragArea = true
end

function GameTimePanel:OnPointerExit()
    self.inDragArea = false
end

function GameTimePanel:OnSubmit()
    local args = 
    {
        startTime = self.curTime,
        addTime = self.addTime,
        callBack = function()
            DayNightMgr.Instance:AddMinute(self.addTime, true)
            self.parentWindow:PlayExitAnim()
        end
    }
    PanelManager.Instance:OpenPanel(GameTimeChangePanel, args)
end