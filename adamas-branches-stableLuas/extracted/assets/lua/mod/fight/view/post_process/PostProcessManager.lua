PostProcessManager = BaseClass("PostProcessManager")

local RootName = "PostProcessRoot"

function PostProcessManager:__init(clientFight)
	self.clientFight = clientFight
	
	self.root = nil
	self.postProcessInvoke = nil
	
	self.postProcess = {}
end

function PostProcessManager:StartFight()
	if not self.root then
		self.root = GameObject(RootName)
		self.root.transform:SetParent(self.clientFight.fightRoot.transform)
	end
	
	self.postProcessInvoke = self.root:GetComponent(PostProcessInvoke)
	if not self.postProcessInvoke then
		self.postProcessInvoke = self.root:AddComponent(PostProcessInvoke)
	end
	
	local templateObj = self.clientFight.assetsPool:Get("AssetsData/PostProcessTemplate.asset")
	self.postProcessInvoke:InitTemplateObj(templateObj)
end

function PostProcessManager:__delete()
end

function PostProcessManager:DeleteMe()
	if not UtilsBase.IsNull(self.root) then
		GameObject.Destroy(self.root)
	end
	
	--for _, v in pairs(self.postProcess) do
		--v:DeleteMe()
	--end
	
	self.root = nil
	self.postProcessInvoke = nil
end

function PostProcessManager:AddPostProcessByTemplateId(id, type, entity)
	local params = self.postProcessInvoke:GetTemplateDate(id, type)
	if not params then
		LogError("找不到后处理配置:"..id)
		return
	end
	self:AddPostProcess(type, params, entity)
end

function PostProcessManager:AddPostProcess(type, params, entity)
	if not self.postProcessInvoke then
		LogError("未正确获取后处理脚本")
		return 
	end
	
	if self.postProcess[type] and not self.postProcess[type]:CanStart() then
		return 
	end
	
	if not self.postProcess[type] then
		self.postProcess[type] = self:GetPostProcess(type)
	end
	
	--params.Entity = entity
	self.postProcess[type]:Start(params, entity)
end

function PostProcessManager:UpdatePostProcess(type, params)
	local postProcess = self.postProcess[type]
	if not postProcess or not postProcess:IsWork() then
		return
	end
	
	postProcess:UpdateState(params)
end

function PostProcessManager:EndPostProcess(type)
	local postProcess = self.postProcess[type]
	if not postProcess or not postProcess:IsWork() then
		return
	end

	postProcess:EndProcess()
end

function PostProcessManager:GetPostProcess(type)
	if type == FightEnum.PostProcessType.RGBSplit then
		return RGBSplitProc.New(type, self.postProcessInvoke)
	elseif type == FightEnum.PostProcessType.RadialBlur then
		return RadialBlurProc.New(type, self.postProcessInvoke)
	elseif type == FightEnum.PostProcessType.BlurMask then
		return BlurMaskProc.New(type, self.postProcessInvoke)
	elseif type == FightEnum.PostProcessType.ColorStyle then
		return ColorStyleProc.New(type, self.postProcessInvoke)
	elseif type == FightEnum.PostProcessType.FullScreen then
		return FullScreenProc.New(type, self.postProcessInvoke)
	end
	
	LogError("未实现的后处理类型:"..type)
end

function PostProcessManager:Update()
	for _, v in pairs(self.postProcess) do
		if v then
			v:Update()
		end
	end
end