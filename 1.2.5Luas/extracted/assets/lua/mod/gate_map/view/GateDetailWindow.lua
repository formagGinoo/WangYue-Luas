
GateDetailWindow = BaseClass("GateDetailWindow",BaseWindow)

function GateDetailWindow:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.gate_detail_ui)

	self.selectIndex = 0
	-- self.InitCompletedEvent = EventLib.New()
end

function GateDetailWindow:__delete()
end

function GateDetailWindow:__CacheObject()
	self.imgSelectList = {}
	self.txtSelectList = {}

	for i = 1, 4 do
		local imgSelect = self.transform:Find("pnlTask/btnTask"..i.."/imgSelect").gameObject
		table.insert(self.imgSelectList, imgSelect)

		local txtSelect = UtilsUI.GetText(self.transform:Find("pnlTask/btnTask"..i.."/text"))
		table.insert(self.txtSelectList, txtSelect)
	end
end

local MAP_NAME_LIST = 
{
	"第一关：春节氛围荒野废墟",
	"第二关：色金之枪内部平台",
	"第三关：色金之枪顶层BOSS平台",
}
function GateDetailWindow:__BindListener()
	local btnReturn = self.transform:Find("btnReturn"):GetComponent(Button)
    btnReturn.onClick:AddListener(function() self:OnReturn() end)

	local btnMain = self.transform:Find("btnMain"):GetComponent(Button)
	btnMain.onClick:AddListener(function() self:OnRetrunMainUI() end)

	for i = 1, 4 do 
		local btnTask = self.transform:Find("pnlTask/btnTask"..i):GetComponent(Button)
		btnTask.onClick:AddListener(function() self:OnSelect(i) end)

		local btnTaskText = UtilsUI.GetText(self.transform:Find("pnlTask/btnTask"..i.."/text"))
		btnTaskText.text = MAP_NAME_LIST[i]

		if i > 3 then
			self.transform:Find("pnlTask/btnTask"..i).gameObject:SetActive(false)
		end
	end

	local btnFight = self.transform:Find("btnFight"):GetComponent(Button)
	btnFight.onClick:AddListener(function() self:OnEnterFight() end)
end

function GateDetailWindow:__Create()
	local canvas = self.gameObject:GetComponent(Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function GateDetailWindow:__Show()

end

function GateDetailWindow:OnSelect(index)
	if self.selectIndex > 0 then
		self.imgSelectList[self.selectIndex]:SetActive(false)
		CustomUnityUtils.SetTextColor(self.txtSelectList[self.selectIndex], 255, 255, 255, 255)	
	end

	self.selectIndex = index

	print("index "..index)
	self.imgSelectList[index]:SetActive(true)
	CustomUnityUtils.SetTextColor(self.txtSelectList[index], 240, 0, 0, 255)	
end

function GateDetailWindow:OnReturn()
	WindowManager.Instance:CloseWindow(GateDetailWindow)
	WindowManager.Instance:OpenWindow(GateMapWindow)
end

function GateDetailWindow:OnRetrunMainUI()
	WindowManager.Instance:CloseWindow(GateDetailWindow)
	WindowManager.Instance:CloseWindow(GateMapWindow)
end

local MAP_ID_LIST = {
	10010012,
	10010013,
	10010014,
}
function GateDetailWindow:OnEnterFight()
	if self.selectIndex == 0 then
		Log("没有地图信息")
		return
	end

	local fightHeroMap = {[1003] = {}, [1004] = {}}
	local selectMapId = MAP_ID_LIST[self.selectIndex]

	WindowManager.Instance:CloseWindow(GateDetailWindow)
	WindowManager.Instance:CloseWindow(GateMapWindow)
	MainDebugManager.Instance.model:InitMainUI()

	local fightData = FightData.New()
	fightData:BuildFightData(fightHeroMap, selectMapId)
	if Fight.Instance then
		Fight.Instance:Clear()
	end

	Fight.New()
	Fight.Instance:EnterFight(fightData:GetFightData())
end