LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π     �      π     � 	     π	     � 
     π
     �   F ��LevelBehavior100030103�SimpleBaseClass�LevelBehaviorBase�GetGenerates�__init�Init�Update�Assignment�ResetCountDown�SpawnEnemy�SpawnRobot�StopMonsterBehavior�ActiveMonsterBehavior�SetEnemyFightTarget�EnableEnemyFightSkill�DisableEnemyFightSkill�DisableRobotFightSkill�GetCloseEnemyInstanceID�SetRobotFightTarget�Die�Death�WeakGuide�RemoveWeakGuide�DisablePlayerInput�BeforeDamage�SetRobotSkill�  ����  �  R   �   �  � � � N  H  �  ���     ��/    a�/    I�/    `�/    ��������� �  ������	�
	����	�	�� R   ���  R   � R   ���������� ��! �"��#��$%� R   ��������&�� ��! �"��#&��$%� R   ��'������(�� ��! �"��#(��$%  R   � *�+�,�-� *�+�.�� *�+�/� ) R   � R   ��1������2�� ��! �"��#2��$&��3��4��	� R   ��1������5�� ��! �"��#5��$��3��4��	 0 R   � R   ��!7��"8��9:��;� R   ��!<��"	��9=��;� R   ��!>��"	��9?��; 6 R   � R   ��!A��"	��BC @G ��fight�role �time�missionState        �guideState�levelCam�missionIsCreated�spawned�totalCount�deathCount�realDeathCount�canAttack�isCount�interval,      �targetFrame�monsterStateEnum�Default�Live       �Dead       �monsterList�entityIda�/    �lev�health�posName�enemy1�wave�id�state�tag�target�player�enemy2I�/    �enemy3�monsterLevelBias�FightEnum�EntityNpcTag�Monster���������Elite�Boss�robotList��/    �robot1�targetframe       �robot2�weakGuide	      �Describe�极限闪避�count�      �攻击引导�      �技能引导�dialogListE	    �describe�继续走，碰到第二波怪物时候，战斗时播放。�   �������� ��  � � �  �   �    � �  ��LevelCommon�BehaviorFunctions�CreateBehavior�LevelCommonFunction�levelId�   �������� 
Ŏ   ��� �  � �  �  �  �  �  � �  �  � 
 ���  	�  	��  � ��  �  �  � �  �  � ��  �  � ��� �� �� �� �� �� �� ��� �  �  � ���
 � �  �  � ���
 � ��  �  �� �� �  8> ��8= ��� � �  �  8 ��� ��h�   � � �� �� ��h�   � �� �  �  � �  � � ��   � �  � � ���   � �  � � ��   � �  � $� � &�  #�  � ' #� ���� (� �   ��)������   *��  �� � 	�.8 ��  � � � ��  / (�  � ��  � 0� � &�  2��  &D� �34�56�� �7 �45�6�� �8�� � �  �� �0� � &� 9�45�6D :� &D�;�  ��LevelCommon�Update�role�BehaviorFunctions�GetCtrlEntity�time�GetEntityFrame�frame�GetFightFrame�playerLifeRatio�GetEntityAttrValueRatio�DoMagic��    �missionIsCreated�spawned�SpawnEnemy�DisableEnemyFightSkill�AddBuff�robotList�id	��    �CheckTaskStepIsFinishmC     �SetEnemyFightTarget�missionState�AddDelayCallByFrame�EnableEnemyFightSkill�StartStoryDialog�dialogList�SetFightMainNodeVisible�L�Core�R�currentTip�AddTipsu�    �levelId�ChangeSubTips�totalCount�LevelCameraLookAtInstance�monsterList�CameraTargetq=
ףp�?333333�?       �deathCount�GetTerrainPositionP�endPos�GetTerrainRotationP�InMapTransport�x�y�z�SetEntityEuler�FixedSetCameraRotationY�SetReviveTransportPos�FinishLevel�      �   �������� � � ���������� �� ��  ��targetFrame        �isCount��������� �  � DK�# 9 �! � � D� �	� � 
�	D� �
 
 � 
"��� 8 �@ 8  ��� �	�  �	�	  � ��� ��		�	�� ��� ��  �� �� ��  ���� ���� L M�$ 6  F� ��ipairs�monsterList�wave�BehaviorFunctions�GetTerrainPositionP�posName�levelId�GetTerrainRotationP�GetTagByEntityId�entityId�GetEcoEntityLevel�monsterLevelBias�lev�id�CreateEntity�x�y�z�SetEntityEuler�state�monsterStateEnum�Live�ShowEntityLifeBarElementBar�EnableEntityElementStateRuning�FightEnum�ElementState�Accumulation�totalCount�   �������� Ë   �  ���������   � �����D�  �ˁ �  �	� �  
� D�� � ��  �
�  �� 
 �
 ��	� �8 ��� 8 ��  �
�  �� 
 �
 ��	� �� ́ �  Ɓ ��BehaviorFunctions�GetEntityPositionOffset�role�ipairs�robotList�GetTerrainPositionP�posName�levelId�GetTerrainRotationP�id�CreateEntity�entityId�x�y�z�state�monsterStateEnum�Live�   �������� �  � DK�  � DL M� 6  F� ��ipairs�BehaviorFunctions�SetEntityValue�id��   �������� �  � DK  � DB  8 � � DL M 6  F� ��ipairs�BehaviorFunctions�HasBuffKind�id	��    �RemoveBuff�   �������� ��    � ˀ> � � 8 ��� � �� �	� 
�� �	�   �� �	��  
�� �	� ���� �	�� ���8+ �� � �( ���� 8' ��   ��$ �� �! ��	�� � �� �	�	�� �	�   �� �	��	   �� �	�� 	�� �	� ���� �	�� ���8 �� �	� 
�� �	�   �� �	��  
�� �	� ���� �	�� ���� �% �  �  ̀? �   ƀ ��ipairs�monsterList�state�monsterStateEnum�Live�target�player�BehaviorFunctions�AddFightTarget�id�role�SetEntityValue�haveWarn�battleTarget�ExitFightRange�targetMaxRange�robotList�tag �setInFight�   �������� �  � DK 9 � � �� �  DL M 6  F� ��ipairs�monsterList�BehaviorFunctions�SetEntityValue�id�canCastSkill�   �������� �  � DK 9 � � �� �  DL M 6  F� ��ipairs�monsterList�BehaviorFunctions�SetEntityValue�id�canCastSkill�   �������� �  � DK 9 � � �� �  DL M 6  F� ��ipairs�robotList�BehaviorFunctions�SetEntityValue�id�canCastSkill�   �������� ��    � �   �  �  �   ƀ ��ipairs�monsterList�   �������� ��    � �  � � 8 �� � �
 ��   �˃ �� 8 �� �	
�
�� �
� 
�� ̓ �  �  �  �   ƀ ��ipairs�robotList�state�monsterStateEnum�Live�monsterList�tag�target�BehaviorFunctions�AddFightTarget�id�SetEntityValue�battleTarget�   �������� ��   �ˁ
 � �
 8 �� �		� �	��� 	� �  8 �� 	�	
 � � � �� ́ �  Ɓ ��ipairs�monsterList�id�instanceId�state�monsterStateEnum�Dead�realDeathCount�currentTip�BehaviorFunctions�ChangeSubTips�totalCount�   �������� 
��   �ˁ �� � �� �		� �	��� 	� �  ���� ́ �  Ɓ ��ipairs�monsterList�id�state�monsterStateEnum�Dead�deathCount�currentTip�   �������� �  �   �� � �	� ���� �  ��  � � �  < � �� �  � � ��Ɓ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�id�state�PlayGuide�   �������� 
��    � ˀ � �� ���  ̀ �   ƀ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�id�   �������� ��  ���   � ��  �ˁ �  �	  �  �� ́ �  � ��  � �  ��  �ˁ �  �	  �  �� ́ �  B  8 ��  �� ���   �� ��  �� ���   �Ɓ ��BehaviorFunctions�CancelJoystick�pairs�FightEnum�KeyEvent�ForbidKey�SetJoyMoveEnable�role�SetFightMainNodeVisible�PanelParent�   �������� ��   �� �	
 
�	 8 ��	 �	
�
��		
9 � �
  �
 	D
K� ��ۅ; 8 �9 ���L
 M� 6
  � � �  Ɔ ��ipairs�monsterList�state�monsterStateEnum�Live�BehaviorFunctions�GetEntityAttrValueRatio�id�health�robotList�   �������� 
��    � � 
 �� 8 �� ���� �� � � �� �	
�� ���  �  �   ƀ ��ipairs�robotList�isCount�targetFrame�frame�interval�BehaviorFunctions�CastSkillByTarget�id�m]    �   ���������