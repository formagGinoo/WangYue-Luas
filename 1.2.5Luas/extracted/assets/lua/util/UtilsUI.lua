-- --------------------------------
-- UI工具类
-- --------------------------------
UtilsUI = BaseClass("UtilsUI")

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
local _floor = math.floor

-- ---------------------------------
-- 添加子对象到父容器，并做基础设置
-- ---------------------------------
function UtilsUI.AddUIChild(parentObj, childObj)
    local trans = childObj.transform
    trans:SetParent(parentObj.transform)
    trans.localScale = Vector3.one
    trans.localPosition = Vector3.zero
    trans.localRotation = Quaternion.identity

    local rect = childObj:GetComponent(RectTransform)
    rect.anchorMax = Vector2.one
    rect.anchorMin = Vector2.zero
    rect.offsetMin = Vector2.zero
    rect.offsetMax = Vector2.zero
    rect.localScale = Vector3.one
    rect.localPosition = Vector3.zero
    rect.anchoredPosition3D = Vector3.zero
    childObj:SetActive(true)

    local canvas = childObj:GetComponent(Canvas)
    if canvas and not canvas:IsNull() then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function UtilsUI.AddBigbg(parentTransform, childObj)
    local childTransform = childObj.transform
    childTransform:SetParent(parentTransform)
    childTransform.localScale = Vector3.one
    childTransform.localPosition = Vector3.zero
    childTransform.anchoredPosition = Vector2.zero

    local rect = childObj:GetComponent(RectTransform)
    rect.anchorMax = Vector2.one
    rect.anchorMin = Vector2.zero
    rect.offsetMin = Vector2.zero
    rect.offsetMax = Vector2.zero
end

--设置特效的层次
--@effectObj  (GameObject)特效对象
--@sortingOrder 设置的层次
function UtilsUI.SetEffectSortingOrder(effectObj, sortingOrder)
    local sortingOrder = sortingOrder or 1
    local particleSystems = effectObj:GetComponentsInChildren(ParticleSystemRenderer)
    for i = 0, particleSystems.Length - 1 do
        particleSystems[i].sortingOrder = sortingOrder
    end

    local meshRender = effectObj:GetComponentsInChildren(MeshRenderer)
    for i = 0, meshRender.Length - 1 do
        meshRender[i].sortingOrder = sortingOrder
    end
end

--使特效在parentTransform的裁剪区域内，要配合Xcqy/Particles/AdditiveMask使用
--@params parentTransform 父Transform
--@params effectTransform 特效
function UtilsUI:SetEffectMask(parentTransform, effectTransform)
    local rectTransform = parentTransform
    local min = rectTransform:TransformPoint(rectTransform.rect.min)
    local max = rectTransform:TransformPoint(rectTransform.rect.max)
    local minX = min.x
    local minY = min.y
    local maxX = max.x
    local maxY = max.y

    local aryParticleSystems = effectTransform:GetComponentsInChildren(ParticleSystemRenderer).Table
    for i, eachParticleSystem in ipairs(aryParticleSystems) do
        local material = eachParticleSystem:GetComponent(Renderer).sharedMaterial
        material:SetFloat("_MinX", minX)
        material:SetFloat("_MinY", minY)
        material:SetFloat("_MaxX", maxX)
        material:SetFloat("_MaxY", maxY)
    end

    local aryMeshRender = effectTransform:GetComponentsInChildren(MeshRenderer).Table
    for k, eachMeshRender in ipairs(aryMeshRender) do
        local material = eachMeshRender:GetComponent(Renderer).sharedMaterial
        material:SetFloat("_MinX", minX)
        material:SetFloat("_MinY", minY)
        material:SetFloat("_MaxX", maxX)
        material:SetFloat("_MaxY", maxY)
    end
end

--保证srcTransform在targetRectTransform的中间
--@param srcTransform 源transform
--@param targetRectTransform 最终指向的transform，注意，此参数必须要是一个RectTransform，如果确定是一个RectTransform，则不需要强制转型
--@param offsetPosition 手动的本地偏移量，可不填
function UtilsUI.SyncPosition(srcTransform, targetRectTransform, offsetPosition)
    local corners = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
    corners = UnityUtils.GetWorldCorners(targetRectTransform, corners)
    --要获取的锚点
    local pivot = Vector2(0.5, 0.5)
    local finalX = corners[1].x * (1 - pivot.x) + corners[3].x * pivot.x
    local finalY = corners[1].y * (1 - pivot.y) + corners[3].y * pivot.y
    srcTransform.position = Vector3(finalX, finalY, 0)

    if offsetPosition then
        --加上手动的偏移量（如果存在，一般来说不需要）
        local offset = Vector3(offsetPosition.x, offsetPosition.y, 0)
        srcTransform.localPosition = offset + srcTransform.localPosition
    end
end

function UtilsUI.CreateRt(rawImage, cameraComp)
    local rect = rawImage.rectTransform.rect
    local factor = math.min(ScreenFactor, 2)
    local rtTemp = CustomUnityUtils.GetTextureTemporary(_floor(rect.width * factor), _floor(rect.height * factor))
    rawImage.texture = rtTemp
    cameraComp.targetTexture = rtTemp
    return rtTemp
end

function UtilsUI.GetContainerObject(transform, refTable)
    local nodes
    local itemUIContainer = transform:GetComponent(UIContainer)
    if itemUIContainer then
        nodes = refTable or {}
        local listName = itemUIContainer.ListName
        local listObjects = itemUIContainer.ListObj

        local listCompName = itemUIContainer.ListCompName
        local listCompObjects = itemUIContainer.ListComponent

        for i = 0, listName.Count - 1 do
            local name = listName[i]
            nodes[name] = listObjects[i]
        end

        for i = 0, listCompName.Count - 1 do
            local name = listCompName[i]
            nodes[name] = listCompObjects[i]
        end
    end

    return nodes
end

function UtilsUI.RegisterPointEvent(gameObject, down, up, drag)
    local pointer = gameObject:AddComponent(UIDragBehaviour)
    pointer.onPointerDown = down
    pointer.onPointerUp = up
    if drag then
        pointer.onDrag = drag
    end
end

function UtilsUI.TextNumScrollAnimation(text, img, startNum, endNum, maxNum, time, updateTime)
    local updateTimes = math.ceil(time / updateTime)
    local add = math.ceil((endNum - startNum) / updateTimes)
    local isAdd = endNum > startNum
    local index = 0
    local callback = function ()
        index = index + 1

        startNum = startNum + add
        if isAdd then
            startNum = math.min(startNum, endNum)
        else
            startNum = math.max(startNum, endNum)
        end

        text.text = startNum

        if img then
            img.fillAmount = startNum / maxNum
        end
    end

    return LuaTimerManager.Instance:AddTimer(updateTimes, updateTime, callback)    
end

function UtilsUI.GetText(gameObject)
    return gameObject:GetComponent(TextMeshProUGUI)
end

function UtilsUI.GetInputField(gameObject)
    return gameObject:GetComponent(TMP_InputField)
end


function UtilsUI.SetTextColor(text,code)
    CustomUnityUtils.SetTextColor(text, code)
end

function UtilsUI.SetImageColor(image,code)
    CustomUnityUtils.SetImageColor(image, code)
end

function UtilsUI.SetHideCallBack(gameObject, callback)
    local hideCallBack = gameObject:GetComponent(HideCallBack)
	if not hideCallBack then
		LogError("HideCallBack 找不到")
		return
	end
    hideCallBack.HideAction:RemoveAllListeners()
    hideCallBack.HideAction:AddListener(callback)
    return hideCallBack
end

function UtilsUI.SetActive(gameObject, active)
    if not gameObject then
        LogError("gameobject为nil")
        return
    end

    if gameObject.activeSelf == active then
        return
    end

    gameObject:SetActive(active)
end

function UtilsUI.SetActiveByScale(gameObject, active)
    CustomUnityUtils.SetActiveByScale(gameObject, active)
end

function UtilsUI.BindButton(table, name, func)
    table[name.."_btn"].onClick:AddListener(function ()
        func()
        if table[name.."_sound"] then
            table[name.."_sound"]:PlayButtonSound()
        end
    end)
end

function UtilsUI.BindHideNode(btn,node,hcb,sound,hideFunc)
    btn.onClick:AddListener(function ()
        if sound then
            sound:PlayExitSound()
        end
        hcb.HideAction:RemoveAllListeners()
        hcb.HideAction:AddListener(hideFunc)
        node:SetActive(false)
    end)
end

function UtilsUI.SetInputImageChanger(gameObject, callback)
    local inputImageChanger = gameObject:GetComponent(InputImageChanger)
    -- if not gameObject:GetComponent(Image) then
    --     LogError("Image 找不到")
	-- 	return
    -- end
    if not gameObject:GetComponent(TextMeshProUGUI) then
        LogError("Text 找不到")
		return
    end
	if not inputImageChanger then
		LogError("InputImageChanger 找不到")
		return
	end
    InputImageChangerManager.Instance:AddChangerListener(inputImageChanger, gameObject, callback)
    return inputImageChanger
end