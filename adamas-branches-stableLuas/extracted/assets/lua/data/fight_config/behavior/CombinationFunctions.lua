CombinationFunctions = {}
--用于处理各种业务层的需求封装

function CombinationFunctions.SetFight(fight)
	CombinationFunctions.fight = fight
end

--获取合法位置，不合法会往外圈扩，positionP参考点，radius第一次取点的随机半径（可为0）
function CombinationFunctions.GetCanBornPosition(positionP,radius)
	local time = 0
	local pos = Vec3.New(positionP.x,positionP.y+0.1,positionP.z)
	while(time<8) do
		pos.x = pos.x + time*0.25
		pos.z = pos.z + time*0.25
		local height = BehaviorFunctions.CheckPosHeight(pos)
		if height then
			height = pos.y - height
			if height - positionP.y <= radius then
				pos.y = height
				return true,pos
			end
		end
		time = time+1
	end
	return true,positionP
end

