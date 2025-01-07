MathX = MathX or {}

MathX.Rad2Deg = math.deg(1)
MathX.Deg2Rad = math.rad(1)

local _atan = math.atan
local _floor = math.floor

function MathX.delta_angle(a1, a2)
	return (a2 - a1 + 180) % 360 - 180
end

function MathX.lerp_angle(a1, a2, p)
	if p > 1 then
		p = 1
	end

	return a1 + ((a2 - a1 + 180) % 360 - 180) * p
end

function MathX.lerp_number(num1, num2, t)
	return num1 + (num2 - num1) * t
end

function MathX.inverse_lerp(min, max, value)
    return (value - min) / (max - min)
end

function MathX.distance(x1, y1, z1, x2, y2, z2)
	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1
	return (dx * dx + dy * dy + dz * dz) ^ 0.5
end

function MathX.square_distance(x1, y1, z1, x2, y2, z2)
	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1
	return dx * dx + dy * dy + dz * dz
end

function MathX.distance2(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1

	return (dx * dx + dy * dy) ^ 0.5
end

function MathX.square_distance2(x1, z1, x2, z2)
	local dx = x2 - x1
	local dz = z2 - z1
 	return dx*dx + dz*dz
end

function MathX.Clamp(value, min, max)
	if value < min then
		value = min
	elseif value > max then
		value = max    
	end
	
	return value
end

function MathX.Sign(num)  
	if num > 0 then
		num = 1
	elseif num < 0 then
		num = -1
	else 
		num = 0
	end

	return num
end

function MathX.dot(x1, y1, x2, y2, x3, y3)
    local dx1, dy1 = x1 - x2, y1 - y2
    local dx2, dy2 = x3 - x2, y3 - y2

    return dx1 * dx2 + dy1 * dy2
end

function MathX.normalize(x, y, z)
	local len = math.sqrt(x * x + y * y + z * z)
	if len > 1e-5 then
		return x / len, y / len, z / len
	else
		return 0, 0, 0
	end
end

function MathX.normalize2(x, z)
    local len = (x * x + z * z) ^ 0.5
    if len > 1e-5 then
        return x / len, z / len
    else
        return 0, 0
    end
end

function MathX.create_vector3(x, y, z)
	return Vector3(x, y, z)
end

function MathX.create_vector2(x, y)
	return Vector2(x, y)
end

function MathX.get_lookat_dir(x1, z1, x2, z2)
	return _floor(_atan(x2 - x1, z2 - z1) * MathX.Rad2Deg) % 360
end

function MathX.CatmulRom(x1, z1, x2, z2, x3, z3, x4, z4, t)
    local ax = -0.5*x1 + 1.5*x2 -1.5*x3 +0.5*x4
    local bx = x1 - 2.5*x2 + 2*x3 - 0.5*x4
    local cx = -0.5*x1 + 0.5*x3
    local dx = x2

    local az = -0.5*z1 + 1.5*z2 -1.5*z3 +0.5*z4
    local bz = z1 - 2.5*z2 + 2*z3 - 0.5*z4
    local cz = -0.5*z1 + 0.5*z3
    local dz = z2

    local x = (((ax*t+bx)*t+cx)*t+dx)
    local z = (((az*t+bz)*t+cz)*t+dz)

    return x, z
end

function MathX.almost_zero2(x, y)
    local len = x * x + y * y
    return len <= 1e-5
end

function MathX.almost_equal(x1, z1, x2, z2)
	local dx = x2 - x1
	local dz = z2 - z1

	local len = dx * dx + dz * dz
	return len <= 0.1
end

function MathX.almost_equal_vec3(v1, v2)
	local dx = v1.x - v2.x
	local dy = v1.y - v2.y
	local dz = v1.z - v2.z

	local len = dx * dx + dy * dy + dz * dz
	return len <= 0.1
end

