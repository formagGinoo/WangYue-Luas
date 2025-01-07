CursorManager = SingleClass("CursorManager")
function CursorManager:__init()
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("CursorManager")
    self.defultCursorPath = "Textures/Icon/SpecialIcon/Cursor/DefaultCursor.png"
    self.resList = { --资源加载表
        {path = self.defultCursorPath, type = AssetType.Object, holdTime = 56}
    }
    self.assetLoader:LoadAll(self.resList)
    self:SetDefaultCursor()
end

function CursorManager:SetDefaultCursor()
    self.assetLoader:AddListener(function()
        local tex = self.assetLoader:Pop(self.defultCursorPath)
        -- tex = self:ScaleTexture(tex, 32, 32)
        Cursor.SetCursor(tex, Vector2(4,4), CursorMode.Auto);
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
    end)
end

function CursorManager:ScaleTexture(originalTexture, newWidth, newHeight)
    local originalPixels = originalTexture:GetPixels()
    local scaledTexture = Texture2D(newWidth, newHeight)

    for y = 0, newHeight - 1 do
        for x = 0, newWidth - 1 do
            local originalX = math.floor(x * (originalTexture.width / newWidth))
            local originalY = math.floor(y * (originalTexture.height / newHeight))

            local originalIndex = originalY * originalTexture.width + originalX
            local scaledIndex = y * newWidth + x

            scaledTexture:SetPixel(x, y, originalPixels[originalIndex])
        end
    end
    scaledTexture:Apply()
    return scaledTexture
end

function CursorManager:__delete()
    Cursor.lockState = CursorLockMode.None
    Cursor.visible = true
end
