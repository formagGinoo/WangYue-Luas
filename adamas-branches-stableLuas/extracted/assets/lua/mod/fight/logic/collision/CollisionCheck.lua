CollisionCheck = {} --CollisionCheck or BaseClass()
--TODO 3D 碰撞,定点数
--TODO 碰撞检测优化 AABB先检测一遍
local Vec3 = Vec3
function CollisionCheck:GJKCheck(collision1,collision2,transInfo)
	--最大迭代次数
	local MAX_ITERATIONS = 32
	local newest_point

	--任意方向，暂定Vec3.right
	local direction = Vec3.right
	local C = self:MinkowskiDiffSupport(collision1,collision2, direction,transInfo)
	--如果该点和原点方向相反，直接返回false
	if Vec3.Dot(C, direction) < 0 then
		return false
	end
	
	--取反 
	direction = -C
	local B = self:MinkowskiDiffSupport(collision1,collision2, direction,transInfo)
	--如果该点和原点方向相反，直接返回false
	if Vec3.Dot(B, direction) < 0 then
		return false
	end
	
	--设置下一个方向为垂直于该线  BC X BO X BC
	direction = self:Cross_ABA(C - B, -B)
	--单形，已经包含两个点，B 和C
	local simplex =
	{
		B, C
	}
	--在最大迭代次数范围内迭代
	for i = 1, MAX_ITERATIONS do
		newest_point = self:MinkowskiDiffSupport(collision1,collision2, direction,transInfo)
		--搜索方向的最远点仍然没有接近原点，false
		if Vec3.Dot(newest_point, direction) < 0 then
			return false
		end

		--对单形状进行操作，
		--如果单形是包含原点的四面体，则返回true
		local check,new_simplex,new_direction = self:DoSimplex(newest_point, simplex, direction)
		simplex = new_simplex
		direction = new_direction
		if check then
			return true
		end
	end
	--超过迭代次数，如果还没检测到，直接返回false
	return false
end

function CollisionCheck:DoSimplex(newest_point,simplex,direction)
	local count = #simplex
	if count == 1 then--线段
		return self:DoSimplexLine(newest_point, simplex, direction)
	elseif count == 2 then--三角形
		return self:DoSimplexTri(newest_point, simplex, direction)
	elseif count == 3 then--四面体
		return self:DoSimplexTetra(newest_point, simplex, direction)
	else
		LogError("simplex error,count = "..count)
		return false
	end
end

function CollisionCheck:DoSimplexLine(A,simplex,direction)
	local B = simplex[1]

	local AB = B - A
	local AO = -A

	if Vec3.Dot(AB, AO) > 0 then
		--原点在A B之间
		simplex = 
		{
			A, B
		}
		--新的搜索方向为垂直于直线，同时朝向原点的方向
		direction = self:Cross_ABA(AB, AO)
	else
		--原点在AO以上区域
		--移除B点
		simplex = 
		{
			A
		}

		--新的搜索方向为AO
		direction = AO
	end
	return false,simplex,direction
end
	
function CollisionCheck:DoSimplexTri(A,simplex,direction)
	--取出第一， 第二个点
	local B = simplex[1]
	local C = simplex[2]
	
	local AO = -A
	
	local AB = B - A
	local AC = C - A
	
	--三角形的法线
	local ABC = Vec3.Cross(AB, AC)
	
	--垂直于三角形AB的垂线
	local ABP = Vec3.Cross(AB, ABC)
	--如果垂线和AO不再同一方向，移除C点
	if Vec3.Dot(ABP, AO) > 0 then
	
	    simplex = 
		{
		    A, B
		}
	    --新的搜索方向为AB在AO方向上的垂线
	    direction = self:Cross_ABA(AB, AO)
	
	    return false,simplex,direction
	end
	
	--垂直于三角形AC的垂线
	local ACP = Vec3.Cross(ABC, AC)
	--如果垂线和AO不再同一方向，移除B点
	if Vec3.Dot(ACP, AO) > 0 then
	    simplex = 
		{
		    A, C
		}
	
	    direction = self:Cross_ABA(AC, AO)
	
	    return false,simplex,direction
	end
	--这里不再需要判断第三个边
	
	--点在三角形上的投影，在三角形的内部，单形增加到三个点
	--法线和AO在相同方向
	if Vec3.Dot(ABC, AO) > 0 then
	
	    simplex = 
		{
		    A, B, C
		}
	
	    --新的搜索方向为三角形的法线方向
	    direction = ABC
	
	else
	    simplex = 
		{
		    A, C, B
		}
	
	    --新的搜索方向为三角形的另一个法线方向
	    direction = -ABC
	end
	
	return false,simplex,direction
end

function CollisionCheck:DoSimplexTetra(A,simplex,direction)
	local B = simplex[1]
	local C = simplex[2]
	local D = simplex[3]
	
	local AO = -A
	
	local AB = B - A
	local AC = C - A
	local AD = D - A
	
	--三个平面指向外面的法线
	local ABC = Vec3.Cross(AB, AC)
	local ACD = Vec3.Cross(AC, AD)
	local ADB = Vec3.Cross(AD, AB)
	
	local over_ABC = Vec3.Dot(ABC, AO) > 0
	local over_ACD = Vec3.Dot(ACD, AO) > 0
	local over_ADB = Vec3.Dot(ADB, AO) > 0
	
	local rotA = A
	local rotB = B
	local rotC = C
	local rotD = D
	local rotAB = AB
	local rotAC = AC
	local rotAD = AD
	local rotABC = ABC
	local rotACD = ACD
	
	if (not over_ABC) and (not over_ACD) and (not over_ADB) then
	    --原点在三个面内部，所以原点在闵科夫斯基差之内
	    --所以碰撞返回true
	    return true,simplex,direction
	elseif over_ABC and (not over_ACD) and (not over_ADB) then
	    --the origin is over ABC, but not ACD or ADB
	
	    rotA = A
	    rotB = B
	    rotC = C
	
	    rotAB = AB
	    rotAC = AC
	
	    rotABC = ABC
	
	    goto check_one_face
	elseif (not over_ABC) and over_ACD and (not over_ADB) then
	    --the origin is over ACD, but not ABC or ADB
	
	    rotA = A
	    rotB = C
	    rotC = D
	
	    rotAB = AC
	    rotAC = AD
	
	    rotABC = ACD
	
	    goto check_one_face
	elseif not over_ABC and (not over_ACD) and  over_ADB then
	    --the origin is over ADB, but not ABC or ACD
	
	    rotA = A
	    rotB = D
	    rotC = B
	
	    rotAB = AD
	    rotAC = AB
	
	    rotABC = ADB
	
	    goto check_one_face
	elseif over_ABC and over_ACD and (not over_ADB) then
	    rotA = A
	    rotB = B
	    rotC = C
	    rotD = D
	
	    rotAB = AB
	    rotAC = AC
	    rotAD = AD
	
	    rotABC = ABC
	    rotACD = ACD
	
	    goto check_two_faces
	elseif (not over_ABC) and over_ACD and over_ADB then
	    rotA = A
	    rotB = C
	    rotC = D
	    rotD = B
	
	    rotAB = AC
	    rotAC = AD
	    rotAD = AB
	
	    rotABC = ACD
	    rotACD = ADB
	
	    goto check_two_faces
	elseif over_ABC and (not over_ACD) and over_ADB then
	    rotA = A
	    rotB = D
	    rotC = B
	    rotD = C
	
	    rotAB = AD
	    rotAC = AB
	    rotAD = AC
	
	    rotABC = ADB
	    rotACD = ABC
	
	    goto check_two_faces
	end
	
	::check_one_face:: do
	
		if Vec3.Dot(Vec3.Cross(rotABC, rotAC), AO) > 0 then
		    simplex = 
			{
			    rotA, rotC
			}
		
		    --新搜索方向 AC x AO x AC
		    direction = self:Cross_ABA(rotAC, AO)
		
		    return false,simplex,direction
		end
	end
						
	::check_one_face_part_2:: do
	
		if Vec3.Dot(Vec3.Cross(rotAB, rotABC), AO) > 0 then
		    simplex =
			{
			    rotA, rotB
			}
		
		    --新搜索方向 AB x AO x AB
		    direction = self:Cross_ABA(rotAB, AO)
		
		    return false,simplex,direction
		end
		simplex =
		{
		    rotA, rotB, rotC
		}
		
		direction = rotABC
		
		return false,simplex,direction
	end
			
	::check_two_faces:: do
		
		if Vec3.Dot(Vec3.Cross(rotABC, rotAC), AO) > 0 then
		
		    rotB = rotC
		    rotC = rotD
		
		    rotAB = rotAC
		    rotAC = rotAD
		
		    rotABC = rotACD
		
		    goto check_one_face
		end
		
		goto check_one_face_part_2
	end
end

--返回一个最极端的闵科夫斯基差，根据前形状，和传入的形状
function CollisionCheck:MinkowskiDiffSupport(collision1,collision2,direction,transInfo)
	--搜索direction方向最远的点
	local my_support = collision1:Support(direction)
	local other_support = collision2:Support(-direction,transInfo)
	--闵可夫斯基差
	local result = my_support - other_support

	return result
end

--AXBXA  的叉积
function CollisionCheck:Cross_ABA(A,B)
	return Vec3.Cross(Vec3.Cross(A, B), A)
end
	
function CollisionCheck:Check(collision1,collision2)
	local type1 = collision1.collisionType
	local type2 = collision2.collisionType
	if type1 == FightEnum.CollisionType.Sphere then
		if type2 == FightEnum.CollisionType.Sphere then
			return CollisionCheck:CheckSphereWithSphere(collision1,collision2)
		else
			return CollisionCheck:CheckSphereWithCube(collision1,collision2)
		end
	else
		if type2 == FightEnum.CollisionType.Sphere then
			return CollisionCheck:CheckSphereWithCube(collision2,collision1)
		else
			return CollisionCheck:CheckCubeWithCube(collision1,collision2)
		end
	end
end

function CollisionCheck:CheckSphereWithSphere(sphere1,sphere2)
	local spherePos1 = sphere1.transformComponent.position
	local spherePos2 = sphere2.transformComponent.position

	local x = spherePos1.x - spherePos2.x
	local z = spherePos1.z - spherePos2.z
	local disSquare = x*x + z*z
	return disSquare < (sphere1.radius + sphere2.radius) * (sphere1.radius + sphere2.radius)
end

function CollisionCheck:CheckSphereWithCube(sphere,cube,transInfo1,transInfo2)

end

function CollisionCheck:CheckCubeWithCube(cube1,cube2,transInfo1,transInfo2)

end