UnityUtils = BaseClass("UnityUtils")

local CustomUnityUtils = CS.CustomUnityUtils
function UnityUtils.SetPosition(transform,x,y,z)
    CustomUnityUtils.SetPosition(transform,x,y,z)
end

function UnityUtils.SetLocalPosition(transform,x,y,z)
    CustomUnityUtils.SetLocalPosition(transform,x,y,z)
end

function UnityUtils.SetLocalScale(transform,x,y,z)
    CustomUnityUtils.SetLocalScale(transform,x,y,z)
 end

function UnityUtils.SetEulerAngles(transform,x,y,z)
    CustomUnityUtils.SetEulerAngles(transform,x,y,z)
end

function UnityUtils.SetGoEulerAngles(gameObject,x,y,z)
    CustomUnityUtils.SetGoEulerAngles(gameObject,x,y,z)
end

function UnityUtils.SetLocalEulerAngles(transform,x,y,z)
    CustomUnityUtils.SetLocalEulerAngles(transform,x,y,z)
end

function UnityUtils.SetAnchoredPosition(transform,x,y)
    CustomUnityUtils.SetAnchoredPosition(transform,x,y)
end

function UnityUtils.SetAnchored3DPosition(transform,x,y,z)
    CustomUnityUtils.SetAnchored3DPosition(transform,x,y,z)
end

function UnityUtils.SetPivot(transform,x,y)
    CustomUnityUtils.SetPivot(transform,x,y)
end

function UnityUtils.SetAnchorMin(transform,x,y)
    CustomUnityUtils.SetAnchorMin(transform,x,y)
end

function UnityUtils.SetAnchorMax(transform,x,y)
    CustomUnityUtils.SetAnchorMax(transform,x,y)
end

function UnityUtils.SetAnchorMinAndMax(transform,min_x,min_y,max_x,max_y)
    CustomUnityUtils.SetAnchorMinAndMax(transform,min_x,min_y,max_x,max_y)
end

function UnityUtils.SetOffsetMin(transform,x,y)
    CustomUnityUtils.SetOffsetMin(transform,x,y)
end

function UnityUtils.SetOffsetMax(transform,x,y)
    CustomUnityUtils.SetOffsetMax(transform,x,y)
end

function UnityUtils.SetOffsetMinAndMax(transform,min_x,min_y,max_x,max_y)
    CustomUnityUtils.SetOffsetMinAndMax(transform,min_x,min_y,max_x,max_y)
end

function UnityUtils.SetSizeDelata(transform,x,y)
    CustomUnityUtils.SetSizeDelata(transform,x,y)
end

function UnityUtils.SetImageColor(image,r,g,b,a)
    CustomUnityUtils.SetImageColor(image,r,g,b,a)
end

function UnityUtils.SetTextColor(text,r,g,b,a)
    CustomUnityUtils.SetTextColor(text,r,g,b,a)
end

function UnityUtils.SetActive(gameObject,active)
    if not gameObject then
        return
    end

    CustomUnityUtils.SetActive(gameObject,active)
end

function UnityUtils.GetHeight(x,y,z,layer)
	return CustomUnityUtils.GetHeight(x,y,z,layer)
end

function UnityUtils.SetRotation(transform,x,y,z,w)
	return CustomUnityUtils.SetRotation(transform,x,y,z,w)
end

function UnityUtils.GraphicsInit()
	CustomUnityUtils.GraphicsInit()
end

function UnityUtils.GraphicsUnload()
	CustomUnityUtils.GraphicsUnload()
end

local sampleStringDic = {}
local sampleStringIndex = 1
function UnityUtils.BeginSample(name,force)
	if force or UnityUtils.Sample and ctx.IsDebug then
        if not sampleStringDic[name] then
            sampleStringIndex = sampleStringIndex + 1
            sampleStringDic[name] = sampleStringIndex
            CustomUnityUtils.AddSampleString(sampleStringIndex,name)
        end
		CustomUnityUtils.BeginSample(sampleStringDic[name])
	end
end


UnityUtils.Sample = false

function UnityUtils.EndSample(force)
	if force or UnityUtils.Sample and ctx.IsDebug then
		CustomUnityUtils.EndSample()
	end
end

function UnityUtils.MoveCheck(startX, startY, startZ, endX, endY, endZ, entityHeight, heightCheck, entityRadius, autoDownHeight)
	return CustomUnityUtils.MoveCheck(startX, startY, startZ, endX, endY, endZ, entityHeight, heightCheck, entityRadius, autoDownHeight)
end

function UnityUtils.GetDistance(startX, startY, startZ, endX, endY, endZ)
	return CustomUnityUtils.GetDistance(startX, startY, startZ, endX, endY, endZ)
end

function UnityUtils.GetTerrainHeight(posX, posY, posZ, layer)
    local height, haveGround, checkLayer = CustomUnityUtils.GetTerrainHeight(posX, posY, posZ, height, haveGround, layer)
    return height, haveGround, checkLayer
end

function UnityUtils.GetDistanceOfOverHead(posX, posY, posZ)
    return CustomUnityUtils.GetDistanceOfOverHead(posX, posY, posZ)
end

function UnityUtils.LineCast(fromX, fromY, fromZ, toX, toY, toZ)
	return CustomUnityUtils.LineCast(fromX, fromY, fromZ, toX, toY, toZ)
end

function UnityUtils.GetWorldCorners(rectTransform, corners)
	return CustomUnityUtils.GetWorldCorners(rectTransform, corners)
end

function UnityUtils.GetGlobalScale(rectTransform)
    local globalScale = rectTransform.localScale
    local parent = rectTransform.parent;

    while parent ~= nil do
        globalScale = Vector3.Scale(globalScale, parent.localScale);
        parent = parent.parent;
        if parent.name == "CanvasContainer" then
            break
        end
    end
    
    return globalScale
end