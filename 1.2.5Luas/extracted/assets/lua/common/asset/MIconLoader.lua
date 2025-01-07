-- 多图集设置
-- setting = {checknil = true/false}
-- @author huangyq
MIconLoader = BaseClass("MIconLoader")
function MIconLoader:__init(gameObject, path, name, callback)
    self.gameObject = gameObject
    self.path = path
    self.name = name
    self.callback = callback

    self.resList = {
        {path = self.path, type = AssetType.Object, holdTime = 56}
    }

    self.assetLoader = nil
    self:CheckPath()
end

function MIconLoader:__delete()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
    self.gameObject = nil
end

function MIconLoader:CheckPath()
    if not BaseUtils.IsNull(self.gameObject) then
        local image = self.gameObject:GetComponent(Image)
        local autoReleaser = self.gameObject:GetComponent(IconAutoReleaser)
        if autoReleaser ~= nil and autoReleaser.path == self.path then
            if image.sprite ~= nil and image.sprite.name == self.name then
                if self.callback ~= nil then
                    self.callback()
                end
                return
            else
                if AssetManager.PoolHasAssetByLogicPath(self.path) then
                    image.sprite = AssetManager.GetSubObject(self.path, self.name)
                    if self.callback ~= nil then
                        self.callback()
                    end
                else
                    LogError("MIconLoader引用计数可能出错了:" .. self.path)
                    self:Load()
                end
            end
        else
            self:Load()
        end
    end
end

function MIconLoader:Load()
    local callback = function()
        self:SetIcon()
    end

    local image = self.gameObject:GetComponent(Image)
    self.originColor = image.color
    image.color = Color(0,0,0,0)

    self.assetLoader = AssetBatchLoader.New("MIconLoader[" .. self.path .. "]");
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(self.resList)
end

function MIconLoader:SetIcon()
    if not BaseUtils.IsNull(self.gameObject) then
        local image = self.gameObject:GetComponent(Image)
        local autoReleaser = self.gameObject:GetComponent(IconAutoReleaser)
        if autoReleaser == nil then
            autoReleaser = self.gameObject:AddComponent(IconAutoReleaser)
        else
            if autoReleaser.path ~= nil and autoReleaser.path ~= "" then
                AssetMgrProxy.Instance:DecreaseReferenceCount(autoReleaser.path)
                image.sprite = nil
            end
        end
        local sprite = AssetManager.GetSubObject(self.path, self.name)
        if sprite ~= nil then
            image.sprite = sprite
        end
        autoReleaser.path = self.path
        AssetMgrProxy.Instance:IncreaseReferenceCount(self.path)
        image.color = self.originColor
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
        if self.callback ~= nil then
            self.callback()
        end
    else
        if self.assetLoader ~= nil then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        end
    end
end

