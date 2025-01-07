-- Automatically generated - do not edit.

Config = Config or {}
Config.DataRuleNote = Config.DataRuleNote or {}


local DataRuleNote = Config.DataRuleNote
DataRuleNote.FindLength = 4
DataRuleNote.Find = {
	["PartnerWorkState"] = {key = "PartnerWorkState", string_val = "<size=34><color=#393f4a>1.饱食度消耗</color></size>\n月灵在资产玩法中，如果处于工作状态时，会随时间消耗饱食度。当饱食度不足时，月灵<color=#ce6600>工作速度下降</color>。饱食度过低时，月灵将进入<color=#ce6600>饥饿</color>状态，工作速度进一步下降。\n\n<size=34><color=#393f4a>2.饱食度恢复</color></size>\n可以在月灵工作的资产中，布置<color=#ce6600>餐桌</color>，并放置足够<color=#ce6600>食物</color>。当月灵饱食度降低时，将前往餐桌<color=#ce6600>自动进食</color>，恢复饱食度。\n\n<size=34><color=#393f4a>3.san值消耗</color></size>\n月灵在资产玩法中，如果处于工作状态时，会随时间消耗san值；如果月灵处于饥饿状态，san值下降速度将加快。当san值不足时，月灵<color=#ce6600>工作速度下降</color>。san值过低时，月灵将进入<color=#ce6600>抑郁</color>状态，工作速度进一步下降。\n\n<size=34><color=#393f4a>4.san值恢复</color></size>\n可以在月灵工作的资产中，布置<color=#ce6600>沙发</color>。当月灵san值降低到一定值时，将自行前往沙发休息，恢复san值。"},
	["PartnerWorkCareer"] = {key = "PartnerWorkCareer", string_val = "<size=34><color=#393f4a>1.职业</color></size>\n不同月灵拥有不同职业，拥有职业的月灵可以在资产设备中工作。不同资产设备，要求不同的职业，只有对应职业的月灵才可在资产中工作。\n在资产中，通过<color=#ce6600>调度中心</color>设备，将月灵放置到资产中， 月灵会自行前往与自己<color=#ce6600>职业匹配的设备</color>中工作。\n\n<size=34><color=#393f4a>2.职业等级</color></size>\n不同月灵除了职业不同外，职业等级也不同。职业等级越高，工作时的<color=#ce6600>工作速度</color>越快。"},
	["PartnerWorkAffix"] = {key = "PartnerWorkAffix", string_val = "<size=34><color=#393f4a>1.职业特性</color></size>\n捕捉月灵后，可查看月灵的职业特性，每一只个体都可能存在差异。\n一只月灵可以有多条职业特性，不同职业特性的效果不同，将会影响该月灵在资产工作时的各种工作指标。\n\n<size=34><color=#393f4a>2.职业特性等级</color></size>\n职业特性等级会因个体而不同。在月灵中心开放<color=#ce6600>机体融合舱</color>后，可通过机体融合舱，对月灵的职业特性进行继承、升级等操作。"},
	["PartnerSkill"] = {key = "PartnerSkill", string_val = "<size=34><color=#393f4a>1.战斗技能</color></size>\n角色佩戴该月灵后，可在战斗中释放的技能。包括主动和连携等。\n\n<size=34><color=#393f4a>2.专属被动</color></size>\n在月灵中心解锁设备<color=#ce6600>能力进化仪</color>后，可<color=#ce6600>消耗材料</color>，在该设备解锁每只月灵的专属被动能力。\n\n<size=34><color=#393f4a>3.探索能力</color></size>\n个别月灵拥有奇特的探索能力，当<color=#ce6600>能力轮盘</color>获得对应能力的道具后，便可召唤月灵使用其探索能力。\n\n<size=34><color=#393f4a>4.通用被动</color></size>\n月灵拥有数个通用被动槽位，随着月灵等级提升而解锁。消耗<color=#ce6600>月灵技能书</color>，月灵可以学习对应通用被动。"},
}
	

return DataRuleNote
