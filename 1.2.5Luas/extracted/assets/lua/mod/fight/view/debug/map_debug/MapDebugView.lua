
local FIGHT_HERO_MAX = 3
local FIGHT_MAP_SAVE_KEY = "MapDebug"

MapDebugView = BaseClass("MapDebugView",BaseView)

function MapDebugView:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.debug_map_window)
end

function MapDebugView:__delete()
end

function MapDebugView:__CacheObject()
	self.cloneMap = self.transform:Find("cloneMap").gameObject
	self.HListCon = self.transform:Find("MaskScrollH/List")
	self.HScrollRect = self.transform:Find("MaskScrollH")
end

function MapDebugView:__BindListener()
	local btnReturn = self.transform:Find("btnReturn"):GetComponent(Button)
    btnReturn.onClick:AddListener(function() self:OnReturn() end)

	local btnEnterFight = self.transform:Find("btnEnterFight"):GetComponent(Button)
	btnEnterFight.onClick:AddListener(function() self:OnEnterFight() end)
end


function MapDebugView:__Create()
	self.HLayout = LuaBoxLayout.New(self.HListCon, {axis = BoxLayoutAxis.X, cspacing = 0, scrollRect = self.HScrollRect})

	local canvas = self.gameObject:GetComponent(Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function MapDebugView:__Show()
	self:updateMapUIList()
	self:updateHeroUI()
end

function MapDebugView:updateMapUIList()
	self.imgSelectList = {}

	local saveMapId = PlayerPrefs.GetString(FIGHT_MAP_SAVE_KEY)
	if saveMapId ~= "" then
		self.selectMapId = tonumber(saveMapId) 
	end

	for k, v in pairs(Config.DataDuplicate.data_duplicate) do
		local item = GameObject.Instantiate(self.cloneMap)
		self.HLayout:AddCell(item)

		local trans = item.transform
		UtilsUI.GetText(trans:Find("contentMap/mapText")).text = k
		local btn = trans:Find("contentMap"):GetComponent(Button)
		btn.onClick:AddListener(function() self:OnMapSelect(k) end)
		
		self.imgSelectList[k] = trans:Find("contentMap/section").gameObject

		-- 默认选中第一个
		if not self.selectMapId or self.selectMapId == k then
			self.selectMapId = k
			self.imgSelectList[k]:SetActive(true)
		else
			self.imgSelectList[k]:SetActive(false)
		end
	end
end

function MapDebugView:OnMapSelect(id)
	for k, v in pairs(self.imgSelectList) do
		v:SetActive(k == id)
	end

	self.selectMapId = id
end

function MapDebugView:updateHeroUI()
	self.fightHeroList = {}

	for i = 1, FIGHT_HERO_MAX do
		local saveKey = "MapDebugHero"..i

		local inputField = self.transform:Find("Panel/inputHero"..i):GetComponent(TMP_InputField)
		local hero_id = PlayerPrefs.GetString(saveKey)
		inputField.text = hero_id
		if hero_id ~= "" then
			self.fightHeroList[i] = tonumber(hero_id)
		end

		local OnEndEdit = function (data)
			if data ~= "" then
				self.fightHeroList[i] = tonumber(data)
			else
				self.fightHeroList[i] = nil
			end

			PlayerPrefs.SetString(saveKey, data)
		end
		inputField.onEndEdit:AddListener(OnEndEdit)
	end
end

function MapDebugView:OnEnterFight()
	local fightHeroMap = {}
	for k, v in pairs(self.fightHeroList) do
		fightHeroMap[v] = {}
	end

	if not next(fightHeroMap) then
		Log("角色信息为空")
		return
	end

	PlayerPrefs.SetString(FIGHT_MAP_SAVE_KEY, tostring(self.selectMapId))

	local fightData = FightData.New()
	fightData:BuildFightData(fightHeroMap, self.selectMapId)
	if Fight.Instance then
		Fight.Instance:Clear()
	end
	Fight.New()
	Fight.Instance:EnterFight(fightData:GetFightData())
	--LoginManager.Instance.model:CloseMainUI()


	self.model:CloseMainUI()
end

function MapDebugView:OnReturn()
	self.model:CloseMainUI()
end