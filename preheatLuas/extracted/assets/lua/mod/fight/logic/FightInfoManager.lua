LuaT �

xV           (w@��� �Q     �   D       �   �  � �	 
� �� R   ���� R    R   �������
 R   ��� !�"#�$%�
 R   �&�'�
 R   � � � N � R   � � � � � � � � �   �  3  χ  4  � 5  χ 6� �  O �8�  O� �9�  O �:�  O� �;�  O �<�  O� �=�   � ?  � R   �  �	! �! �
" �" �# � 	  ω 	G	$ �	  O
 �	I�	% 
  ϊ 
K
  �
 
L
  ϊ 
M
' �
  O �
O�
(  R   �Q�R�S�T� U�@V��W����X�����Y�����Z�����[�����\�����]�����^�����_�����`��0 �b��1 �d��2 �f��3 �h��4 �j�  O� �k�6   �	 m7 �  O�	 �o�8   �
 q  ύ
 r  � sF���FightInfoManager�SimpleBaseClass�RoleConfig�Config�DataWeapon�Find�BehaviorFunctions�FightEnum�string�format�MapPositionConfig�DataMapTransport�WildFight�野外战斗�NightMare�梦魇终战�MainFight�主线战斗�StartFight�野外战斗-战斗开始�EndFight�野外战斗-战斗结束�KillMonster�野外战斗-击杀怪物�PlayerDeath�野外战斗-觉醒者死亡�PlayerDeathComplete�野外战斗-灭队�PlayerRevive�野外战斗-复活�梦魇终战-战斗开始�梦魇终战-战斗结束�UseSkill�梦魇终战-技能释放�SkillDamage�梦魇终战-技能伤害�ChangeRole�梦魇终战-切换觉醒者�主线战斗-战斗开始�主线战斗-战斗结束�剧情/任务触发战斗�玩家主动攻击怪物�进入怪物警戒状态�白�绿�蓝�紫�橙�红�{"队伍信息":
{
%s
}
}
�"觉醒者%d": {
"名称": "%s",
"等级": %d,
"回路等级": %d,
"技能总等级": %d,
"挂载武器": "%s",
"武器等级": %d,
"武器精炼等级": %d,
"挂载月灵": "%s",
"月灵等级": %d,
"月灵品质": "%s"
}
�__init�__delete�GetTeamRoleInfo�OnPlayerEnterBattle�{"总造成伤害":%f,
"总受到伤害":%f,
"治疗量":%f,
"本次战斗时长":%f}
�ResetInFightInfo�OnPlayerLeaveBattle�CheckInFight�OnDoDamage�DoCure�OnEntityDie�{"怪物名称":%s,
"怪物等级":%d}
�MonsterDie�{"觉醒者名称":%s,
"地图":%s,
"位置":{%f,%f,%f},
"致死单位":%s,
"致死原因":%s}
�伤害�逻辑调用直接死亡(GM)�淹死�摔死�处决�捕捉�PlayerDie�{"最后死亡觉醒者名称":%s,
"地图":%s,
"位置":{%f,%f,%f},
"致死单位":%s,
"致死原因":%s}
�TeamDeath�{"复活点":"%d",
"位置":{%f,%f,%f}}
�Revive�GetMapPositionConfigByPositionId�ReviveWithEcoId�{"队伍信息":
{
%s
"关卡":"%s",
"挑战积分":%d
}
}
�EnterNightMare�{"角色":%s,
"技能Id":%s,
"技能类型":"%s"}
�普攻�技能�核心技能�五行绝技�五行绝技起手�闪避�前闪避�后闪避�跳反�跳反踩踏�跳反攻击�下落攻击�下落攻击起手�下落攻击循环�下落攻击落地�连携技能       �变身技能       �召唤技能       �月灵主动技能       �月能构造-快速创建        �月能构造-快速驾驶�OnSkillCast�{"角色":%s,
"技能类型":"%s"
"伤害":%f}
�SendDamageInfo�{"切换前觉醒者":"%s",
"切换后觉醒者":"%s"}
�OnCurRoleChange�{"总造成伤害":%f,
"总受到伤害":%f,
"治疗量":%f,
"本次战斗时长":%.2f,
"获得积分":%d}
�NightMareComplete�OnPlayerInMainFight�OnPlayerEndMainFight�  ���� ��  R   ��������������	��
��  �  R   ��������������	��
�������� �   R    �  � ���  ������  R   �������� ��! �  ��baseInfo�header_type�fight�unixtime �log_id�type�name�result�info�ext�session_id�posInfo�location_x�location_y�location_z�teamInfoTable�fightSessionId�LogReportManager�Instance�GenLogId�inWildFight�inNightMare�levelconfig�systemDuplicateId�inMainFight�inFightInfo�totalDmg        �totalHurt�totalHeal�startTimeStamp�endTimeStamp�   �������� ��  R   ��������������	��
��  �  R   ��������������	��
�������� �   R    �������  R   ���������� �  ��baseInfo�header_type�fight�unixtime �log_id�type�name�result�info�ext�session_id�posInfo�location_x�location_y�location_z�teamInfoTable�fightSessionId        �inWildFight�inNightMare�levelconfig�systemDuplicateId�inMainFight�inFightInfo�totalDmg�totalHurt�totalHeal�startTimeStamp�endTimeStamp��������� '��   �  � �  � ���  	 �	D	K�? ��� �	  D  
� D� C� 8  � Á 8  ����C� 8  ���B  �	 �  �DB�  � � �DK "���.L M 6  8  ����B  �
 � �� D  B  8 � �D� �8 � �����8 � �����B  � �=� 8 � ��    D  B  8 � �D� ��	 �8 �� ��� 8 �� ���  � 	 �   �   �   �   �  	 �
   D D L	 M�@ 6	  	 4	 >	� �
 �	 	�	 	
 �
  4 �/�� �������� ����� ��� D
 D	 ���F� ��TableUtils�ClearTable�teamInfoTable�mod�FormationCtrl�GetCurFormationInfo�pairs�roleList�RoleCtrl�GetRoleData�GetRoleConfig�name�无�lev�star�skill_list�IsTableEmpty�ex_lev�weapon_id�BagCtrl�GetWeaponData�ItemConfig�GetItemConfig�template_id�refine�partner_id�GetPartnerData�PartnerConfig�GetPartnerConfig�quality�table�insert�       �������� 	��  DB  8  �G � � �� 	�
D  � �� � �	��
� � �� � �   �  �Á 8  �� �	 � � � D� � � 4 � �ʁ �  �   � � 9� � �� � �   � � 	 �   D�� �  � ��  � �5 �� �	��� �� ��� ��CheckInFight�inWildFight�inFightInfo�startTimeStamp�TimeUtils�GetCurTimestamp�fightSessionId�LogReportManager�Instance�GenLogId�baseInfo�unixtime�log_id�type�WildFight�name�StartFight�result        �info�session_id�GetTeamRoleInfo��teamInfoTable�,�ext�LogInfo�FightInfo : �SendLogMessage �    	 
     �������� ��   ���   ���   ���   ���   ���  ��inFightInfo�totalDmg        �totalHurt�totalHeal�startTimeStamp�endTimeStamp��������� 	Î     8  ��  � �   D� �   D� �   	
�D� �  � �  � �  ���   � �  	 �  � � � � ��D� �� � �  �   � ��  � � �5 � �  	� 
��� � �  ��inWildFight�inFightInfo�endTimeStamp�TimeUtils�GetCurTimestamp�baseInfo�unixtime�log_id�LogReportManager�Instance�GenLogId�type�WildFight�name�EndFight�result       �session_id�fightSessionId�ext�totalDmg�totalHurt�totalHeal�startTimeStamp�ResetInFightInfo�LogInfo�FightInfo : �SendLogMessage�    	     �������� ��     � ��    8  ��  �  �  ��inNightMare�inWildFight�inMainFight��������� ��  DB�  8  �G  �   D�   �  �B  �  �  8  �G B  8 ���9 8 � � ���G B  8
 ���9 8 � � ��� 	B  � �� 
  �  	 D� �B  8 �B  8
 ���9 � � � ��� 	B  8 �� 
�  	 DG ��CheckInFight�GetEntity�tagComponent�npcTag�EntityNpcTag�Player�inFightInfo�totalHurt�totalDmg�inNightMare�SendDamageInfo�parent�  �������� ���  �  8  �� �   �  �  8  �G B  8 ���9 8 � � ����	 �B  8 �B  8 ���9 � � � ���G ��CheckInFight�GetEntity�tagComponent�npcTag�EntityNpcTag�Player�inFightInfo�totalHeal�parent�  �������� 
�  B�  8  �G  �   DB  �
 ���  8	 ������  � ��� �   � �� ������  8 ��� � �� ��inWildFight�GetEntity�tagComponent�IsPlayer�PlayerDie�IsMonster�MonsterDie� �������� 
� B�  8  �G  �  B  � � �DB  8 ��8 �Á 8  ��  �  
D�	�  �D�� �� �� ���  �� 	 �   � D�� �  � �� � � �5 �� ���� �� ��attrComponent�npcConfig�next�name�config�DefaultName�未知怪物�level�baseInfo�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�type�WildFight�KillMonster�result       �session_id�fightSessionId�ext�LogInfo�FightInfo : �SendLogMessage�    	     �������� �  �D�����   D� �	  B  8 ��	�  � ��	
B  � � �
DB  8 �
8 �C� 8 �8 �8  �� �  D��  �D�� �� �� ���  �� �� !� � #�"� 	 �   � �!	#�	
  
	 D	�$� �  � �� % � �$5 �� ���'� �� ��Fight�Instance�GetFightMap�GetRoleConfig�masterId�name�transformComponent�position�GetEntity�attrComponent�npcConfig�next�config�DefaultName�entityId�非实体来源�posInfo�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�GenLogId�type�WildFight�PlayerDeath�result       �session_id�fightSessionId�location_x�x�location_y�y�location_z�z�ext�LogInfo�FightInfo : �SendLogMessage�       	     �������� �  B�  8  �G  �D����	�   D� �	  B  8 ��
�  � ��
B  � � �DB  8 �8 �C� 8 �8 �8  � �  D��  �D�� �� �� ���  ��  �� "�!� $�#� 	 �   �  �"	$�	
  
	 D	�%� �  � �� &� � �%5 �� ���(� ��� )�� ��inWildFight�Fight�Instance�GetFightMap�GetRoleConfig�masterId�name�transformComponent�position�GetEntity�attrComponent�npcConfig�next�config�DefaultName�entityId�非实体来源�posInfo�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�GenLogId�type�WildFight�PlayerDeathComplete�result       �session_id�fightSessionId�location_x�x�location_y�y�location_z�z�ext�LogInfo�FightInfo : �SendLogMessage�OnPlayerLeaveBattle�       	     �������� ��   ��  ��  ���   ��  �	�  �
�  ��  	 �   �   � D��  D��  �D�� �  � ���
 �  �5 ������  �� ��posInfo�type�WildFight�name�PlayerRevive�result        �session_id�fightSessionId�location_x�location_y�location_z�ext�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�LogInfo�FightInfo : �SendLogMessage� 	        �������� �B  �  �  8  �G   � DB  8 ��  �  8  ��   8 ��  �  �� � ��� � ��  � ��  8  �� ��  8 ��  �  ���� � ��GetMapPositionData�next��    �������� ۉ  �  8  �G �    ��DB  8 ��  �  8  �� ��0����D��0� 	�
	 	��		 	� 	� 	 	 	 	 	� 	 �   �   �	 	��	�	 	��	��	�		 B  � ��  	
� D� 	DG ��GetMapPositionConfigByPositionId�position�next�math�floor�x'      �y�z�posInfo�type�WildFight�name�PlayerRevive�result        �session_id�fightSessionId�location_x�location_y�location_z�ext�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�LogInfo�FightInfo : �SendLogMessage�     	     �������� 	攀  � �   8  ��  �  � ���  �  �  �  �	�� 
� �  � ���  �  � ��� � D � �� � � � �  � �� � ����� � �  4 � �ʁ �   �   �  � 9� � �� � �   � � 	 �   � �  D�"� �  � �� # � �"5 �� ���%� �� ��&� ��CheckInFight�systemDuplicateId�mod�DuplicateCtrl�GetSystemDuplicateId�levelconfig�NightMareConfig�GetDataNightmareDuplicate�inNightMare�ResetInFightInfo�fightSessionId�LogReportManager�Instance�GenLogId�NightMareDuplicateCtrl�GetMaxTypePoint�GetTeamRoleInfo�baseInfo�type�NightMare�name�StartFight�result        �info�session_id�unixtime�TimeUtils�GetCurTimestamp�log_id��teamInfoTable�,�ext�LogInfo�FightInfo : �SendLogMessage �    	     �������� ю    8  �� �   �  �B�  8  �G �DB  8 ��DB�  8  �� � �		 �	�	
	 � � �		 � 		 C� 8  ��  � 	 �   � �	 ��	�	 ��	��	�		 B  � ���  
� D� D �G ��inNightMare�GetEntity�tagComponent�IsPlayer�GetRoleConfig�masterId�name�baseInfo�type�NightMare�UseSkill�result       �info�levelconfig�session_id�fightSessionId�未知技能类型�ext�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�LogInfo�FightInfo : �SendLogMessage �   	         �������� �  � D�DB�  8 ��  � �� �  ��  � �� 8  � � 	�
� 	�� 	��� 	 �� 	 �� 		 �   �   D�� 	 D�� 	 �D�� �  � ��  � 	�	5 �� ���� 	�� 	���  � �� ��UnityUtils�BeginSample�FightInfoManager:SendDamageInfo�GetRoleConfig�masterId�EndSample�name�skillType�非技能伤害�baseInfo�type�NightMare�SkillDamage�result       �info�levelconfig�session_id�fightSessionId�ext�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�LogInfo�FightInfo SendDamageInfo 
: �SendLogMessage �      	     �������� Ŏ    8  �� �   �  � �   D���D� �� �� ��	
�  ��  �� 	 � �D�� D�� �D�� �  � �� � �	5 ������ �� ��� ��inNightMare�GetEntity�GetRoleConfig�masterId�baseInfo�type�NightMare�name�ChangeRole�result       �info�levelconfig�session_id�fightSessionId�ext�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�LogInfo�FightInfo : �SendLogMessage �   	        �������� ܎     8  ��  �  � ���  � ��	
�  8 � ��  � � � � �  � �� � ���� � D� ����B  8 �B�  8  ���� 	 �   � �	! 
"�   D��� #��$�$� %� �  � �� &� � �5 �� ���(� �� ��$� ��inNightMare�mod�DuplicateCtrl�GetDupResult�baseInfo�type�NightMare�name�EndFight�FightResult�Win�result              �info�levelconfig�session_id�fightSessionId�unixtime�TimeUtils�GetCurTimestamp�log_id�LogReportManager�Instance�GenLogId�GetDuplicateStateBySysId�systemDuplicateId�NightMareDuplicateCtrl�GetNightMareDuplicateUseTime�current_score�ext�inFightInfo�totalDmg�totalHurt�totalHeal�ResetInFightInfo �LogInfo�FightInfo : �SendLogMessage�    	      �������� 	��  DB  8  �G � � �� 	�
D   � �� � �	��
� � �� � �   8  ��  � � D � � 4 � �ʁ �  �   � � 9� � ��  �   � � 	 �   D�� �  � �� � � �5 �� �	��� �� ��� ��CheckInFight�inMainFight�inFightInfo�startTimeStamp�TimeUtils�GetCurTimestamp�fightSessionId�LogReportManager�Instance�GenLogId�fightTarget�baseInfo�unixtime�log_id�type�MainFight�name�StartFight�result        �info�session_id�GetTeamRoleInfo��teamInfoTable�,�ext�LogInfo�FightInfo : �SendLogMessage �    	     �������� ̎    8  �� � �  D��  D��  	
�D�� �� �� ��  B�  8  �  ��  �� 	 �  � � � �	 
�	
�
D��� �� �  � ��  � �5 �� 	�
��� �� ���� ��inMainFight�inFightInfo�endTimeStamp�TimeUtils�GetCurTimestamp�baseInfo�unixtime�log_id�LogReportManager�Instance�GenLogId�type�MainFight�name�EndFight�result�info�fightTarget�session_id�fightSessionId�ext�totalDmg�totalHurt�totalHeal�startTimeStamp�ResetInFightInfo�LogInfo�FightInfo : �SendLogMessage �    	     ���������