local Math = MathX

local math  = math
local acos	= math.acos
local sqrt 	= math.sqrt
local max 	= math.max
local min 	= math.min
local clamp = Math.Clamp
local cos	= math.cos
local sin	= math.sin
local abs	= math.abs
local sign	= Math.Sign
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local type = type

local _cos = math.cos
local _sin = math.sin
local _atan = math.atan

local rad2Deg = Math.Rad2Deg
local deg2Rad = Math.Deg2Rad

Vec3 = Vec3 or {}
Vec3.__index = Vec3

function Vec3.ConstNew(x, y, z)
	local ret = {
		__const = {x = x or 0, y = y or 0, z = z or 0}
	}
	setmetatable(ret, Vec3)

	return ret
end

local _constNew = Vec3.ConstNew

function Vec3.New(x, y, z)
	local v = {x = x or 0, y = y or 0, z = z or 0}
	setmetatable(v, Vec3)
	return v
end

local _new = Vec3.New

Vec3.__call = function(t,x,y,z)
	return _new(x,y,z)
end

function Vec3.CreateByUnityVec3(q)
	return _new(q.x, q.y, q.z, q.w)
end

function Vec3.CreateByCustom(q)
	return _new(q.x, q.y, q.z)
end

function Vec3:ToUnityVec3()
	return Vector3(self.x, self.y, self.z)
end
	
function Vec3:Set(x,y,z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function Vec3:SetA(vec)
	self.x = vec.x or 0
	self.y = vec.y or 0
	self.z = vec.z or 0
	return self
end

function Vec3:Get()			
	return self.x, self.y, self.z	
end

function Vec3:GetArray()
	return {self.x, self.y, self.z}
end

function Vec3:Clone()
	return _new(self.x, self.y, self.z)
end

function Vec3:ToRight()
	return _new(self.z, self.y, -self.x)
end

function Vec3.Distance(va, vb)
	return sqrt((va.x - vb.x)^2 + (va.y - vb.y)^2 + (va.z - vb.z)^2)
end

function Vec3.DistanceXZ(va, vb)
	return sqrt((va.x - vb.x)^2 + (va.z - vb.z)^2)
end

function Vec3.SquareDistance(a, b)
	return ((a.x -b.x) * (a.x -b.x) + (a.y - b.y) * (a.y - b.y) + (a.z - b.z) * (a.z - b.z))
end

function Vec3.SquareDistanceXZ(a, b)
	return ((a.x -b.x) ^ 2 + (a.z - b.z) ^ 2)
end

function Vec3.Dot(lhs, rhs)
	return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
end

function Vec3.Lerp(from, to, t)	
	t = clamp(t, 0, 1)
	return _new(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function Vec3.LerpB(from, tx, ty, tz, t)
	t = clamp(t, 0, 1)
	return from.x + (tx - from.x) * t, from.y + (ty - from.y) * t, from.z + (tz - from.z) * t
end

function Vec3.LerpA(from, to, t, out)	
	t = clamp(t, 0, 1)
	out:Set(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function Vec3.LerpC(from, to, t)
	t = clamp(t, 0, 1)
	return from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t
end

function Vec3:Magnitude()
	return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vec3.Max(lhs, rhs)
	return _new(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
end

function Vec3.Min(lhs, rhs)
	return _new(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
end

function Vec3.Normalize(v)
	local x,y,z = v.x, v.y, v.z		
	local num = sqrt(x * x + y * y + z * z)	
	
	if num > 1e-5 then		
		return _new(x/num, y/num, z/num)   			
    end
	  
	return _new(0, 0, 0)			
end

function Vec3:SetNormalize()
	local num = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	
	if num > 1e-5 then    
        self.x = self.x / num
		self.y = self.y / num
		self.z = self.z /num
    else    
		self.x = 0
		self.y = 0
		self.z = 0
	end 

	return self
end
	
function Vec3:SqrMagnitude()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

local dot = Vec3.Dot

function Vec3.Angle(from, to)
	return acos(clamp(dot(from:Normalize(), to:Normalize()), -1, 1)) * rad2Deg
end

function Vec3.Angle2(from, to)
	return acos(clamp(dot(from, to), -1, 1)) * rad2Deg
end

function Vec3:ClampMagnitude(maxLength)	
	if self:SqrMagnitude() > (maxLength * maxLength) then    
		self:SetNormalize()
		self:Mul(maxLength)        
    end
	
    return self
end

function Vec3.OrthoNormalize(va, vb, vc)	
	va:SetNormalize()
	vb:Sub(vb:Project(va))
	vb:SetNormalize()
	
	if vc == nil then
		return va, vb
	end
	
	vc:Sub(vc:Project(va))
	vc:Sub(vc:Project(vb))
	vc:SetNormalize()		
	return va, vb, vc
end

--[[function Vec3.RotateTowards2(from, to, maxRadiansDelta, maxMagnitudeDelta)	
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)
	
	local dota	= dot(v1, v2)
	local angle = acos(dota)			
	local theta = min(angle, maxRadiansDelta)	
	local len	= 0
	
	if len1 < len2 then
		len = min(len2, len1 + maxMagnitudeDelta)
	elseif len1 == len2 then
		len = len1
	else
		len = max(len2, len1 - maxMagnitudeDelta)
	end
						    
    v2:Sub(v1 * dota)
    v2:SetNormalize()     
	v2:Mul(sin(theta))
	v1:Mul(cos(theta))
	v2:Add(v1)
	v2:SetNormalize()
	v2:Mul(len)
	return v2	
end

function Vec3.RotateTowards1(from, to, maxRadiansDelta, maxMagnitudeDelta)	
	local omega, sinom, scale0, scale1, len, theta
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)
	
	local cosom = dot(v1, v2)
	
	if len1 < len2 then
		len = min(len2, len1 + maxMagnitudeDelta)	
	elseif len1 == len2 then
		len = len1
	else
		len = max(len2, len1 - maxMagnitudeDelta)
	end 	
	
	if 1 - cosom > 1e-6 then	
		omega 	= acos(cosom)
		theta 	= min(omega, maxRadiansDelta)		
		sinom 	= sin(omega)
		scale0 	= sin(omega - theta) / sinom
		scale1 	= sin(theta) / sinom
		
		v1:Mul(scale0)
		v2:Mul(scale1)
		v2:Add(v1)
		v2:Mul(len)
		return v2
	else 		
		v1:Mul(len)
		return v1
	end			
end]]
	
function Vec3.MoveTowards(current, target, maxDistanceDelta)	
	local delta = target - current	
    local sqrDelta = delta:SqrMagnitude()
	local sqrDistance = maxDistanceDelta * maxDistanceDelta
	
    if sqrDelta > sqrDistance then    
		local magnitude = sqrt(sqrDelta)
		
		if magnitude > 1e-6 then
			delta:Mul(maxDistanceDelta / magnitude)
			delta:Add(current)
			return delta
		else
			return current:Clone()
		end
    end
	
    return target:Clone()
end

function Vec3:AlmostZero()
	local len = self:SqrMagnitude()
	return len <= 0.1
end

function Vec3:Rotate2(radian)
	local cos = _cos(radian)
	local sin = _sin(radian)

	local x = self.x * cos + self.y * sin
	local y = self.y * cos + self.x * sin

	return Vec3.New(x, 0, y)
end

function ClampedMove(lhs, rhs, clampedDelta)
	local delta = rhs - lhs
	
	if delta > 0 then
		return lhs + min(delta, clampedDelta)
	else
		return lhs - min(-delta, clampedDelta)
	end
end

local overSqrt2 = 0.7071067811865475244008443621048490

local function OrthoNormalVector(vec)
	local res = _new()
	
	if abs(vec.z) > overSqrt2 then			
		local a = vec.y * vec.y + vec.z * vec.z
		local k = 1 / sqrt (a)
		res.x = 0
		res.y = -vec.z * k
		res.z = vec.y * k
	else			
		local a = vec.x * vec.x + vec.y * vec.y
		local k = 1 / sqrt (a)
		res.x = -vec.y * k
		res.y = vec.x * k
		res.z = 0
	end
	
	return res
end

function Vec3.RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta)
	local len1 = current:Magnitude()
	local len2 = target:Magnitude()
	
	if len1 > 1e-6 and len2 > 1e-6 then	
		local from = current / len1
		local to = target / len2		
		local cosom = dot(from, to)
				
		if cosom > 1 - 1e-6 then		
			return Vec3.MoveTowards (current, target, maxMagnitudeDelta)		
		elseif cosom < -1 + 1e-6 then		
			local axis = OrthoNormalVector(from)						
			local q = Quaternion.AngleAxis(maxRadiansDelta * rad2Deg, axis)	
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		else		
			local angle = acos(cosom)
			local axis = Vec3.Cross(from, to)
			axis:SetNormalize ()
			local q = Quaternion.AngleAxis(min(maxRadiansDelta, angle) * rad2Deg, axis)			
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		end
	end
		
	return Vec3.MoveTowards(current, target, maxMagnitudeDelta)
end
	
function Vec3.SmoothDamp(current, target, currentVelocity, smoothTime)
	local maxSpeed = math.huge
	local deltaTime = Global.elapsed
    smoothTime = max(0.0001, smoothTime)
    local num = 2 / smoothTime
    local num2 = num * deltaTime
    local num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)    
    local vector2 = target:Clone()
    local maxLength = maxSpeed * smoothTime
	local vector = current - target
    vector:ClampMagnitude(maxLength)
    target = current - vector
    local vec3 = (currentVelocity + (vector * num)) * deltaTime
    currentVelocity = (currentVelocity - (vec3 * num)) * num3
    local vector4 = target + (vector + vec3) * num3	
	
    if Vec3.Dot(vector2 - current, vector4 - vector2) > 0 then    
        vector4 = vector2
        currentVelocity:Set(0,0,0)
    end
	
    return vector4, currentVelocity
end	
	
function Vec3.Scale(a, b)
	local x = a.x * b.x
	local y = a.y * b.y
	local z = a.z * b.z	
	return _new(x, y, z)
end

function Vec3:CrossA(rhs)
	local lhs = self
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	self:Set(x,y,z)	
	return self
end

function Vec3:CrossB(lhs)
	local rhs = self
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	self:Set(x,y,z)	
	return self
end

function Vec3.Cross(lhs, rhs)
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	return _new(x,y,z)	
end
	
function Vec3:Equals(other)
	return self.x == other.x and self.y == other.y and self.z == other.z
end
		
function Vec3.Reflect(inDirection, inNormal)
	local num = -2 * dot(inNormal, inDirection)
	inNormal = inNormal * num
	inNormal:Add(inDirection)
	return inNormal
end

	
function Vec3.Project(vector, onNormal)
	local num = onNormal:SqrMagnitude()
	
	if num < 1.175494e-38 then	
		return _new(0,0,0)
	end
	
	local num2 = dot(vector, onNormal)
	local v3 = onNormal:Clone()
	v3:Mul(num2/num)	
	return v3
end
	
function Vec3:ProjectA(onNormal)
	local num = onNormal:SqrMagnitude()
	
	if num < 1.175494e-38 then	
		return _new(0,0,0)
	end
	
	local num2 = dot(self, onNormal)
	self:SetA(onNormal)
	self:Mul(num2/num)	
	return self
end
	
function Vec3.ProjectOnPlane(vector, planeNormal)
	local v3 = Vec3.Project(vector, planeNormal)
	v3:Mul(-1)
	v3:Add(vector)
	return v3
end

function Vec3:ProjectOnPlaneA(planeNormal,cache)
	cache:SetA(self)
	self:ProjectA(planeNormal)
	self:Mul(-1)
	self:Add(cache)
	return self
end	

function Vec3.Slerp(from, to, t)
	local omega, sinom, scale0, scale1

	if t <= 0 then		
		return from:Clone()
	elseif t >= 1 then		
		return to:Clone()
	end
	
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)

	local len 	= (len2 - len1) * t + len1
	local cosom = dot(v1, v2)
	
	if 1 - cosom > 1e-6 then
		omega 	= acos(cosom)
		sinom 	= sin(omega)
		scale0 	= sin((1 - t) * omega) / sinom
		scale1 	= sin(t * omega) / sinom
	else 
		scale0 = 1 - t
		scale1 = t
	end

	v1:Mul(scale0)
	v2:Mul(scale1)
	v2:Add(v1)
	v2:Mul(len)
	return v2
end
-- 贝塞尔曲线
function Vec3:CalculateBezierPoint(t, p0, p1, p2,cache1,cache2,cache3,result)
    local u = 1 - t
    local tt = t * t
    local uu = u * u

	cache1 = cache1 or Vec3.New(0,0,0)
	cache2 = cache2 or Vec3.New(0,0,0)
	cache3 = cache3 or Vec3.New(0,0,0)
	cache1:SetA(p0)
	cache2:SetA(p1)
	cache3:SetA(p2)

	cache1:Mul(uu)
	cache2:Mul( 2 *u * t)
	cache3:Mul( tt)

	result = result or Vec3.New()
	result:Set(cache1.x + cache2.x + cache3.x, cache1.y + cache2.y + cache3.y, cache1.z + cache2.z + cache3.z)
	return result
end
--CatmullRom插值曲线
function Vec3:CalculateCatMullRomPoint(t, p0, p1, p2, p3,cache1,cache2,cache3,result)
    
	local t2 = t * t;
	local t3 = t2 * t;

	cache1:SetA(p1)
	cache1:Mul(2)

	cache2:SetA(p2)
	cache2:Sub(p0)
	cache2:Mul(t)

	cache1:Add(cache2)

	cache2:SetA(p0)
	cache2:Mul(2)
	cache3:SetA(p1)
	cache3:Mul(5)
	cache2:Sub(cache3)
	cache3:SetA(p2)
	cache3:Mul(4)
	cache2:Add(cache3)
	cache3:SetA(p3)
	cache2:Sub(cache3)
	cache2:Mul(t2)
	
	cache1:Add(cache2)
	
	cache2:SetA(p0)
	cache2:Mul(-1)
	cache3:SetA(p1)
	cache3:Mul(3)
	cache2:Add(cache3)
	cache3:SetA(p2)
	cache3:Mul(3)
	cache2:Sub(cache3)
	cache3:SetA(p3)
	cache2:Add(cache3)
	cache2:Mul(t3)
		
	cache1:Add(cache2)
	cache1:Mul(0.5)

	--[[
	local point =
		0.5 * ((2 * p1) +
				(-p0 + p2) * t +
				(2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 +
				(-p0 + 3 * p1 - 3 * p2 + p3) * t3);]]

	return result:SetA(cache1);
end

function Vec3:Mul(q)
	if type(q) == "number" then
		self.x = self.x * q
		self.y = self.y * q
		self.z = self.z * q
	else
		self:MulQuat(q)
	end
	
	return self
end

function Vec3:Div(d)
	self.x = self.x / d
	self.y = self.y / d
	self.z = self.z / d
	
	return self
end

function Vec3:Add(vb)
	self.x = self.x + vb.x
	self.y = self.y + vb.y
	self.z = self.z + vb.z
	
	return self
end

function Vec3:AddXYZ(x, y, z)
	self.x = self.x + (x or 0)
	self.y = self.y + (y or 0)
	self.z = self.z + (z or 0)
	
	return self
end


function Vec3:Sub(vb)
	self.x = self.x - vb.x
	self.y = self.y - vb.y
	self.z = self.z - vb.z
	
	return self
end

function Vec3:SubXYZ(x, y, z)
	self.x = self.x - x
	self.y = self.y - y
	self.z = self.z - z
	
	return self
end

function Vec3:MulQuat(quat)	   
	local num 	= quat.x * 2
	local num2 	= quat.y * 2
	local num3 	= quat.z * 2
	local num4 	= quat.x * num
	local num5 	= quat.y * num2
	local num6 	= quat.z * num3
	local num7 	= quat.x * num2
	local num8 	= quat.x * num3
	local num9 	= quat.y * num3
	local num10 = quat.w * num
	local num11 = quat.w * num2
	local num12 = quat.w * num3
	
	local x = (((1 - (num5 + num6)) * self.x) + ((num7 - num12) * self.y)) + ((num8 + num11) * self.z)
	local y = (((num7 + num12) * self.x) + ((1 - (num4 + num6)) * self.y)) + ((num9 - num10) * self.z)
	local z = (((num8 - num11) * self.x) + ((num9 + num10) * self.y)) + ((1 - (num4 + num5)) * self.z)
	
	self:Set(x, y, z)	
	return self
end

function Vec3.AngleAroundAxis (from, to, axis)	 	 
	from = from - Vec3.Project(from, axis)
	to = to - Vec3.Project(to, axis) 	    
	local angle = Vec3.Angle (from, to)	   	    
	return angle * (Vec3.Dot (axis, Vec3.Cross (from, to)) < 0 and -1 or 1)
end

function Vec3.AngleSigned(from, to)
	return _atan(
        Vec3.Dot(Vec3.up, Vec3.Cross(from, to))/
        Vec3.Dot(from, to)) * rad2Deg
end

 Vec3.__tostring = function(self)
 	return "["..self.x..","..self.y..","..self.z.."]"
 end

Vec3.__div = function(va, d)
	return _new(va.x / d, va.y / d, va.z / d)
end

Vec3.__mul = function(va, d)
	if type(d) == "number" then
		return _new(va.x * d, va.y * d, va.z * d)
	else
		local vec = va:Clone()
		vec:MulQuat(d)
		return vec
	end	
end

Vec3.__add = function(va, vb)
	return _new(va.x + vb.x, va.y + vb.y, va.z + vb.z)
end

Vec3.__sub = function(va, vb)
	return _new(va.x - vb.x, va.y - vb.y, va.z - vb.z)
end

Vec3.__unm = function(va)
	return _new(-va.x, -va.y, -va.z)
end

Vec3.__eq = function(a,b)
	local v = a - b
	local delta = v:SqrMagnitude()
	return delta < 1e-10
end

Vec3.__index = function(tbl, key)
	local __const = rawget(tbl, "__const")
	if __const then
		return __const[key] or Vec3[key]
	else
		return Vec3[key]
	end
end

Vec3.__newindex = function(tbl, key)
	assert(nil, "const vec3 不能赋值")
end

Vec3.up 		= _constNew(0,1,0)
Vec3.down 		= _constNew(0,-1,0)
Vec3.right		= _constNew(1,0,0)
Vec3.left		= _constNew(-1,0,0)
Vec3.forward 	= _constNew(0,0,1)
Vec3.back		= _constNew(0,0,-1)
Vec3.zero		= _constNew(0,0,0)
Vec3.one		= _constNew(1,1,1)

Vec3.magnitude	= Vec3.Magnitude
Vec3.normalized	= Vec3.Normalize
Vec3.sqrMagnitude= Vec3.SqrMagnitude

