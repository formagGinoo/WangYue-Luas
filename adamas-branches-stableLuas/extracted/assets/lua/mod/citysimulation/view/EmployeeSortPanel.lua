EmployeeSortPanel = BaseClass("EmployeeSortPanel", BasePanel)

local Black = Color(64 / 255, 67 / 255, 74 / 255, 1)
local White = Color(1, 1, 1, 1)

function EmployeeSortPanel:__init(parent)
    self:SetAsset("Prefabs/UI/CitySimulation/EmployeeSortPanel.prefab")
    
    self.selectType = 0
end

function EmployeeSortPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.CancelBtn_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    
    -- 排序规则
    for i = 1, 6 do
        local textName = "SortText" .. i .. "_txt"
        local selectName = "SortSelect" .. i
        local onToggleFunc = function(isSelect)
            if isSelect then
                self:SetSelectType(i)
                self[textName].color = White
            else
                self[textName].color = Black
            end
            self[selectName]:SetActive(isSelect)
        end

        onToggleFunc(i == 1)    -- 初始化
        self["Sort" .. i .. "_tog"].onValueChanged:RemoveAllListeners()
        self["Sort" .. i .. "_tog"].onValueChanged:AddListener(onToggleFunc)
    end
end

function EmployeeSortPanel:__Show()
    
end

function EmployeeSortPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function EmployeeSortPanel:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function EmployeeSortPanel:SetSelectType(_type)
    self.selectType = _type
end

function EmployeeSortPanel:InitLocalizationText()
    self.TitleText_txt = TI18N("排序")
    self.SortRuleText_txt = TI18N("排序规则")
    self.RuleSortText1_txt = TI18N("默认")
    self.RuleSortText2_txt = TI18N("评级")
    self.AbilitySortText_txt = TI18N("能力排序")
    self.AbilityText1_txt = TI18N("人气能力")
    self.AbilityText2_txt = TI18N("专业能力")
    self.AbilityText3_txt = TI18N("工作态度")
    self.AbilityText4_txt = TI18N("身体素质")
    self.ConfirmBtnText_txt = TI18N("确认")
    self.CancelBtnText_txt = TI18N("取消")
end

function EmployeeSortPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end