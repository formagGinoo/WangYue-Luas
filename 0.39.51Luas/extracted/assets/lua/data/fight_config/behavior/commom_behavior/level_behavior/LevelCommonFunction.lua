LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π     �      π     � 	     π	     � 
     π
     �      π     �      π     �      π     �      π      �   !   π  "   �   #   π  $   �   %   π  &   �   '   π  (   �   )   π  *   �   +   π  ,   �   -   π  .   �   /   π  0   �   1   π  2   �   3   π  4   �   5   π  6   �   7   π  8   �   9   π  :   �   ;   π  <   �   =   π  >   �   ?   π  @   �   A   π  BF ��LevelCommonFunction�SimpleBaseClass�LevelBehaviorBase�GetGenerates�Init�LateInit�Update�SetPlayerPos�CheckPlayerInArea�LevelCreateEntity�LevelCreateMonster�SummonMonster�SetMonsterPatrol�CheckInFight�CompanyFight�LevelStop�LevelContinue�ShowEnemyRemainTips�ShowWaveTips�SetCamBlend�CameraReduce�LevelCameraLookAtInstance�LevelCameraLookAtPos�LevelCameraInsToIns�LevelCameraPosToPos�ChangeLevelCameraTarget�RemoveLevelCamera�SetCamBlendInEnd�CameraAutoRemove�DisablePlayerInput�GetDistanceBetweenPos�ReturnPosition�AddLevelDelayCallByTime�AddLevelDelayCallByFrame�RemoveAllLevelDelayCall�RogueGuidePointer�NPCPlayAnimation�NPCActIn�NPCActLoop�NPCActEnd�Assignment�SetAsTaskLevel�TaskLevelFSM�SetAsChallengeLevel�ChallengeLevelFSM�SetAsRogueLevel�RogueLevelFSM�LevelSuccessCondition�LevelFailCondition�LevelStart�ReturnLevelState�ResetLevel�SuccessCondition_DefeatAllEnemy�FailCondition_TimeLimit�FailCondition_Distance�FailCondition_LeavingArea�FailCondition_DistanceToIns�EnterArea�ExitArea�Remove�RemoveLevel�FinishLevel�TimerCountFinish�OnSwitchPlayerCtrl�Death�RemoveEntity�ReturnLevelResult�  ����  �   R   H  �  ���������� �� �  � 胈  � 
 �  R   ����	
�������� �  �  ���  R     R   �  �   R    �  R    �� ��  �� �!�"�#�$�%�&
�'�  R   ����)
��*��+��, (�  R   ��.��/
��0��1 -�  -� . 2�3�4�5�6�7�8�9�:�;�<�=�>�   R    ?�@�A�B�C�D�E�   R    F�G�HI�J�K�L�  R    OP� N OR� Q OT� S M�  M� N U�V�   R    W�X�  ��role �levelController�BehaviorFunctions�CreateEntity�levelId�levelStateEnum�Default        �Start       �Ongoing       �LevelSuccess       �LevelFail       �LevelEnd       �levelState�levelName�默认关卡名称�isSuccess�entityList�list�monsterList�monsterLevelBias�FightEnum�EntityNpcTag�Monster�Elite�Boss�currentGroupNum�totalDeadMonsterNum�totalMonsterNum�actList�defaultActing�defaultActNum�defaultActState�defaultActStateEnum�In�Loop�Out�End�levelTypeEnum�NoType�TaskLevel�ChallengeLevel�RogueLevel�levelType�formationDead�showWaveTips�waveTips�showEnemyRemainTips�startCount�warningCountDownId�warningCountDownSecond�warningCountDownFinish�distanceLimit�distanceWarningCurrentTime�distanceWarningEndTime�warningSecond�areaLimitNameList�leavingArea�leavingTips�timeLimit�timeLimitTimer�timeLimitFinish�timeLimitSecond�levelCameraGroup�currentCamGroupNum�guideDistance2       �guide�guideEntity�guidePos�GuideTypeEnum�Police�GuideType�Rogue_Police�Challenge�Rogue_Challenge�Riddle�Rogue_Riddle�guideType�rogueEventId�delayCallList�currentdelayCallNum�   �������� ��  ���������� ��     � ��  � �   �� � �� � �   �  8  �8 ��   �  8 ��� 	� 8 ��   
�  8 ��� � 8 ��   �  �  ��� � �  ��role�BehaviorFunctions�GetCtrlEntity�CheckInFight�CameraAutoRemove�levelType�levelTypeEnum�NoType�ChallengeLevel�ChallengeLevelFSM�TaskLevel�TaskLevelFSM�RogueLevel�RogueLevelFSM�   �������� 
��  �  � �  ��D  �  D�  � �  ���  �	���� ��BehaviorFunctions�GetTerrainPositionP�levelId�InMapTransport�x�y�z�DoLookAtPositionImmediately�role�CameraPosReduction�   �������� ��  ���������� �  B  � �  �   �ˁ ��  � ���  8 �� �	�  � 
�  D�  8 �� ��  		�	
	� 
  �
��� ́ �  � �� Ɓ 8 � �	 DF� ��levelId�ipairs�id�posName�BehaviorFunctions�GetTerrainPositionP�GetTerrainRotationP�instanceId�CreateEntity�x�y�z�lev�isDead�entityList�list�LogError�没有在行为树中对LevelCommonFunction中的levelId变量赋值，请检查行为树�   �������� �  B  8 � R   ����� ���� � 	�
 �   ��  � �� �  �	
�	�
 8 ��  �	
�
� � �  �  �� �  ����  � 4 �� �  �Ɓ 8 � �� DF� ��levelId�list�monsterNum        �currentWave       �deadMonsterNum�topWave�currentGroupNum�table�insert�monsterList�ipairs�wave�SummonMonster�totalMonsterNum�LogError�没有在行为树中对LevelCommonFunction中的levelId变量赋值，请检查行为树�   �������� �  �  �ˁQ ��  �O ���
 �M ���  �J �� �	� � 
	� D�  �@ �� �
� � D� ��.=� 8 �< � �� �  �� � � D �  �			�		
 � D �D��  8 �����  8 � �� 	 � D��<� �  ��� �B  8 �  R   �  	�� � �  � �  !�   D� � �  � �"	��  
 �$�/�$ %�	
�	


DB  8 �� "�	 �	 'D "�	 �	  D "�� ��'�D "�	 ��'�D8 �� � � � 5 �8 �� � �� ́R �  F� Ɓ ��ipairs�list�id�wave�currentWave�posName�BehaviorFunctions�GetTerrainPositionP�levelId�GetTerrainRotationP�GetTagByEntityId�GetEcoEntityLevel�monsterLevelBias�lev �LogError�怪物世界等级偏移低于0级，请检查怪物世界等级偏移值�instanceId�CreateEntity�x�y�z�GetEntity�tagComponent�IsMonster�你小子，是不是用创怪节点创了不是怪物的东西？ LevelBehaviorId：�isDead�infight�engage�patrolList�table�insert�SetEntityValue�patrolPositionList�monsterNum�SetEntityEuler�battleTarget�role�haveWarn�ExitFightRange�targetMaxRange�未找到对应刷怪点位：� 请检查点位数据：�PosName为nil,请检查monsterList数据�   �������� �B  8 ��  R     � DK  
�	  D� �  �
 �L M 6   � � � DƁ ��ipairs�BehaviorFunctions�GetTerrainPositionP�levelId�table�insert�SetEntityValue�patrolPositionList�   �������� ��    � �   8 ��  � � ��  �  �˂ � �
��  8 �� �
�� � �
 D� ͂	 �  ɀ ƀ ��next�monsterList�currentGroupNum�ipairs�list�BehaviorFunctions�CheckEntity�instanceId�GetEntityValue�inFight�getBattleTarget�infight�   �������� � ��   �J�0  � ��DK, B  8* �< �( � �� D� �
� � �D� � �B  8 ��  8 �:� 8 � �	��DA� 8 �F� 8  �F�  � ��DK� �9� 8 �B  � � 
�DB  8 �; 8
 �� ���   �� �� �� ���	  �� ��L M� 6  L M- 6  I1 F� ��currentGroupNum�ipairs�monsterList�list�instanceId�infight�BehaviorFunctions�GetEntityValue�getExitFightRange�GetDistanceFromTarget�role�GetPositionP�math�abs�y�SetEntityValue�setInFight�AddFightTarget�battleTarget�OnMonsterEnterFight�   �������� ��   �  � � � �  ��BehaviorFunctions�DoMagic�LevelController��    �   �������� ��   �  �� � �  ��BehaviorFunctions�RemoveBuff�LevelController��    �   �������� ��   � �  B  8  �  �  � �� �  �   � 8 �� �� �   � � � � � �  	5 ��
8 � � D�
G ��击败所有敌人�countTips�BehaviorFunctions�AddTips�levelId��    �ChangeSubTips�totalDeadMonsterNum�/�totalMonsterNum�showEnemyRemainTips�RemoveTips�   �������� ��   �  �� 8  �� G ��showWaveTips��������� �  B  8 �� �� �   �� ���B  �  �0�� 	�    � 
 �  ��  � �� � ��   �� �333333�?�BehaviorFunctions�SetVCCameraBlend�**ANY CAMERA**�LevelCamera�levelCameraGroup�blendInEnd�������?�AddDelayCallByTime�SetCamBlendInEnd�currentCamGroupNum�   �������� ��   R    D� � �   ��Y�� � � 0�   @�� 8 � >R � � ���DG ��x�y�z�BehaviorFunctions�GetCameraRotationh      �CameraPosReduction�   �������� ��  D R   ��� �	��� 	� �		 
�   ��� �   � �� 
 �	
 
�  �	 D
�
� 
 �	
�� �	 � �� �	 
� 

�   �� �	 
� 

�   �A � ��� �    �  �� � � ��CameraReduce�camEntity �lookatEntity�rolesBindTransform�blendIn�blendOut�currentCamGroupNum�table�insert�levelCameraGroup�SetCamBlend�BehaviorFunctions�CreateEntity�levelId�lookatTarget�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   �������� 甃  �� R   ������� �/�  	� 
 � D�  �   D �  D� 
 �	
 
��  �� �	 D
�
� 
 �	
 
�  �	 D
�
� �	 � 
 ����  � �� �	 
� 

�   �� �� �	 
� 

� �� �	 
� 

� 
 ���A � ��� �    �  �� � � ��CameraReduce�camEntity �lookatEntity�rolesBindTransform�blendIn�blendOut�currentCamGroupNum�table�insert�levelCameraGroup�SetCamBlend�BehaviorFunctions�GetTerrainPositionP�levelId�CreateEntity�x�y�z�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   ��������	 Ô�  �� R   �������� 
�/� 
 
	� 
 �	 D�  �   D 
� 
� �  � 
 �
 
� 
 
� 
 ��  � D 
� 
 ��  � DA � ��   �   � D H G ��CameraReduce�camEntity �followEntity�lookatEntity�blendIn�blendOut�currentCamGroupNum�table�insert�levelCameraGroup�SetCamBlend�BehaviorFunctions�CreateEntity�levelId�lookatTarget�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   �������� 锃  �� R   �������� �/�  	� 
 � D�  �   D �  D� �	  � � 
� 
� �胈  �� 
 �
 
� 
� �胈  	�		� 
 �
 
� 
� �  � 
 �
 
� 
 �� 
� D 
� 
 �� 
� DA � ��   �   � D H G ��CameraReduce�camEntity �followEntity�lookatEntity�blendIn�blendOut�currentCamGroupNum�table�insert�levelCameraGroup�SetCamBlend�BehaviorFunctions�GetTerrainPositionP�levelId�CreateEntity�x�y�z�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   �������� ʎ  � � � ��  �Ƃ �   �� � � ��
�  8 �� �
��  8 �� �
��B  8 �� �	  � 
�  	� �胈  �	�	  
�
 �   ��  	D8 ��  8 �� �  � �   �� � �  Ƃ ��levelCameraGroup�LogError�levelCommon相机组为空�ipairs�lookatEntity�BehaviorFunctions�CheckEntity�RemoveEntity �GetTerrainPositionP�levelId�CreateEntity�x�y�z�CameraEntityLockTarget�currentCamGroupNum�camEntity�   �������� �  4 ? � � � DF�  �  DK� 9 8 �B  8 � �DB  8 � �D��	B  8 � �	DB  8 � �	D��	
B  � �� 
�  ��  �� D� 
�  � � �� DL M� 6  F� ��levelCameraGroup�LogError�levelCommon相机组为空�ipairs�camEntity�BehaviorFunctions�CheckEntity�RemoveEntity �lookatEntity�blendOut�AddDelayCallByTime�SetVCCameraBlend�**ANY CAMERA**�LevelCamera333333�?�   �������� ��  ��� ��levelCameraGroup�blendInEnd��������� �   �  �  8/ ��    � � , � ��  � �� �	��  8 �� �	�  �  � ���  �  �� ���  8  �� � 
 ��  8 �� �	 
�
 �� �	���� ��  8 �� ��� �  ��Y�� � �08 ��� � ��  � ��� �	 8 ��� � ��  � ��� � �B  � ���  8 �@�� �  �>R 8 ��� � �� �	
 ��  � - �   ƀ ��levelCameraGroup�ipairs�camEntity�BehaviorFunctions�CheckEntity�GetEntity�followEntity�lookatTarget�lookatEntity�GetDistanceFromTarget�role�clientTransformComponent�GetTransform�LevelCamera�GetEntityTransformRoth      �RemoveLevelCamera      �?�blendInEnd�CameraPosReduction�������?�   �������� ��  ���   � ��  �ˁ �  �	  �  �� ́ �  � ��  � �  ��  �ˁ �  �	  �  �� ́ �  B  8 ��  �� ���   �� ��  �� ���   �Ɓ ��BehaviorFunctions�CancelJoystick�pairs�FightEnum�KeyEvent�ForbidKey�SetJoyMoveEnable�role�SetFightMainNodeVisible�PanelParent�   �������� �  D�  �  �  �  D�  �  � �� G ��BehaviorFunctions�GetCtrlEntity�GetPositionP�GetTerrainPositionP�levelId�GetDistanceFromPos�   �������� ��  R     R   �    � �J2   �   � D�  �  � � D� � 	 ��  � �	"	.		"	.	�	  	�	  
 �
  D	�  8 ��	  �	 
 �
	   �	�	 � �� 
  
�
   � D
� 8 ��	  �	 
 �
   �	� �	  �	 
 �
   �	  � ��	  �	 
 �	�	� � ��
 	�

�
9� 8 ��
 	�

�
9
 � ��
  �
  �
�
  8 ��
 �
  � �
�
 �
  � �
I�2 4 =� � � 
� �4 D�
� 8 �4 =� � � 
� �4 D�
� � �B�  8 �  H 8  �� G ��BehaviorFunctions�GetPositionOffsetBySelf�GetPositionP�TableUtils�CopyTable�y�GetDistanceBetweenObstaclesAndPos�CheckObstaclesBetweenPos�CheckPosHeight�FightEnum�Layer�Terrain�Default�CheckPosIsInScreen�table�insert�math�random�   ��������
�Q  �    �   �  D � ���� � � �   �F���AddDelayCallByFrame�currentdelayCallNum�table�insert�delayCallList�   ��������
�Q  �    �   �  D � ���� � � �   �F���AddDelayCallByFrame�currentdelayCallNum�table�insert�delayCallList�   �������� 
��    � ˀ �� � ��  ̀ �   ƀ ��ipairs�delayCallList�RemoveDelayCall�   �������� Ҏ  �  � �� �  �  �  �� �� �  � �� � �  8 �� � �� �
 � �   D; � ��   � �� �胈    �  �	  
�  �
 � � � ���  � 8	 �� �  8 �� � ��  8 �� � ��� � ��� ��guidePos�BehaviorFunctions�GetTerrainPositionP�position�positionId�logicName�rogueEventId�GetRoguelikePointInfo�LogError�没有在行为树中对LevelCommonFunction中的rogueEventId变量赋值，请检查行为树�GetPositionP�role�GetDistanceFromPos�guide�guideEntity�CreateEntity�x�y�z�levelId�AddEntityGuidePointer�CheckEntity�RemoveEntity �RemoveEntityGuidePointer�   �������� �  �  �  ��  8 ��  � 8 �� � �� �   � �� � �   � 5 �  �	  � ���~ 8 �
�
�  �		  � �"�"
	.	H � �  	�   D=�~ �  �H 8 ��  �   �5 �G ��BehaviorFunctions�CanCtrl�defaultActState�defaultActStateEnum�Default�In�NPCActIn�_in�__end�GetEntityAnimationFrame       �LogError�没有该动画，无法返回时长 缺失动作为 �tostring�   �������� �  � �9 8! � B�  � �  � 5 � �  � ���~ � � �   � �		�	
D�   �   �   D�   �   ��   D�   �   �   � D8
 �   �   D�   �   �   D�   �   ��   D�G ��defaultActState�defaultActStateEnum�In�defaultActing�_in�BehaviorFunctions�GetEntityAnimationFrame�PlayAnimation�FightEnum�AnimationLayer�PerformLayer�AddDelayCallByFrame�Assignment�Loop�NPCActLoop�End�   �������� �  � �9 8 � B�  � �  � 5 � �  �  	�� �
  � ��  � ��~ � ��� � �����   �   �   D�   �   ��   D�   �   �   D� ��  � ��~ � �   �G ��defaultActState�defaultActStateEnum�Loop�defaultActing�_loop�BehaviorFunctions�PlayAnimation�FightEnum�AnimationLayer�PerformLayer�GetEntityAnimationFrame       �AddDelayCallByFrame�Assignment�Out�NPCActEnd�Default �   �������� ��   � � ��   8 ��  �  �   � ��	D 
�   D��� �    �   � ���� ��/�   �   � ���� �    � � �  �� ��defaultActState�defaultActStateEnum�Out�defaultActing�_end�BehaviorFunctions�PlayAnimation�FightEnum�AnimationLayer�PerformLayer�GetEntityAnimationFrame�AddDelayCallByFrame�Assignment�End�Default�   �������� � � ���������� ��    �� 8 ��  �   �  ��levelType�levelTypeEnum�TaskLevel��������� Ȏ    �  8  �8  ��    �  � ��  �   � ��    �  8  �� ��    �  8 ���  �   � ��    	�  8 ��
�  �   � ��    �  8 ��� �  � �� �  � �  �   � ��  �  � �  �  8 ��  �  � � ��  �  � �  ��levelState�levelStateEnum�Default�Start�Ongoing�LevelSuccess�isSuccess�LevelEnd�LevelFail�ShowEnemyRemainTips�ShowWaveTips�timeLimitTimerId�BehaviorFunctions�StopLevelTimer�FinishLevel�levelId�RemoveLevel�   �������� ��   �� 8 ��  �  ��8  � B  8  ��� �  � ��levelType�levelTypeEnum�ChallengeLevel �levelName�startCount��������� Ў    �  8  �8$ ��    �  � ��  �   8  �� ��  �   8  �����  �   � ��    �  8  �� ��    �  8 ��	�  � 
  � ��    �  8 ���  � 
  � ��    
�  8 ��� �  � �� �  � �  �   � ��  �  � �  � 	 8 ��  �  � � ��  �  � �  ��levelState�levelStateEnum�Default�Start�startCount�levelName�Ongoing�LevelSuccess�isSuccess�LevelEnd�LevelFail�ShowEnemyRemainTips�ShowWaveTips�timeLimitTimerId�BehaviorFunctions�StopLevelTimer�FinishLevel�levelId�RemoveLevel�   �������� ��   �� � ��   8
 ��  � �� � 8 ��  � �� � 8 ��  � �� � 8 �� � �B  � �� 
  �� �  � 8 �� � �� �  � ��levelType�levelTypeEnum�RogueLevel�Police�guideType�GuideTypeEnum�Challenge�Riddle�LogError�没有该类型的肉鸽事件�type�number�guideDistance�你在距离参数这里压根没输入数字，采用默认距离50。�   �������	� �    �  8 ��� �  � 8, ��    �  � ��  �  	
	�   � �  �   �# ��    �  8  ��  ��    �  8 ��  �  	
�   � ��  �   � ��    �  8 ��  �  	
�   � ��  �   � ��    �  8 ��� �  � �� �  � �  �   � ��  �  � �  �  8 ��  �  � � ��  �  � �  ��levelState�levelStateEnum�Default�RogueGuidePointer�guideDistance�guideType�Start�BehaviorFunctions�ShowCommonTitle�WorldTitlePanel�TitleType�levelName�Ongoing�LevelSuccess�CityThreatenEnd�isSuccess�LevelEnd�LevelFail�ShowEnemyRemainTips�ShowWaveTips�timeLimitTimerId�StopLevelTimer�FinishLevel�levelId�RemoveLevel�   ������	�	���   �   R   P  �   4 ���  � DK � �  �����L M 6  � � � � �9 8 �  �  �  DF���ipairs�levelState�levelStateEnum�Ongoing�LevelSuccess�ReturnLevelResult�levelId�   ������	�	���   �   R   P  �     � DK � � � � �	9	 8 �  �  �  DL M 6  F���ipairs�levelState�levelStateEnum�Ongoing�LevelFail�ReturnLevelResult�levelId�   ������	�	� ��    �  8 ��  �   �  ��levelState�levelStateEnum�Default�Start�������	�	� ��   �  �  ��levelState�������	�	� �� ���   R    �  ��currentGroupNum        �totalDeadMonsterNum�totalMonsterNum�monsterList�������	�	� ��   � � �9 8 �  H 8 � �: 8 �  H ���G ��deadMonsterNum�monsterNum�������	�	� �  < � � �  D � � � 	B  8 �  H �  �  H G ��timeLimit�timeLimitTimerId�BehaviorFunctions�StartLevelTimer�FightEnum�DuplicateTimerType�FightTargetUI�timeLimitFinish�   ������	�
� �  � �  �  D�  �  � �B  8 �: 8 �  � D�  H : 8  � 	<
 8 �  D  ��"	.	  �	� �  D  � � 8 � �  �	
�
�	�D� :	 � � �   8 ��  �	
 �  � D �  	8 ��  �	 � �8 �  � D�  H 8 � 	< � ��	
  � D�  H G ��BehaviorFunctions�GetPositionP�role�GetTerrainPositionP�levelId�GetDistanceFromPos�RemoveTips�leavingTips �distanceLimit�distanceWarningCurrentTime�GetFightFrame�distanceWarningEndTime       �warningSecond�math�ceil�AddTips��    �ChangeTitleTips�   ������
�
� �  �   �� �
� 8 ��
� �  �  �  �� � �  B�  � �� R   ���� �   � D� 	
�   D  �    � DK B�  8  ��  L M 6   B�  8 �  8 � B�  � � �  D �8	 � B  � ��  � � B  � � � D � D��� B  8 � � DB  8 �� �  � B�  8 � �  � �  � D  8 � �   D B  � ��  F� �  �  F� F� ��ipairs�areaLimitNameList�areaName�logicName�inArea�BehaviorFunctions�CheckEntityInArea�role�table�insert�leavingArea�warningCountDownId�StartLevelTimer�FightEnum�DuplicateTimerType�CountDown�StopLevelTimer�RemoveTips�leavingTips �ReturnLevelTimerTime�math�ceil�AddTips��    �levelId�ChangeTitleTips�warningCountDownFinish�   ������
�� �  � DB�  � � ��  � � D  H   �   DB  8 �: 8 ��  � 	��	
�  � : 8" �� � 8 ��  �� � ���  �� ��  �� �  : 8 �� � � #	.	0� � � �  	B�  8 ��
 �  8  �  �  �	  �  � D �  		8 �  � 	  D8 ��  � 	��	
�  � 8 �� � � ���  � 	��	
�  � � ��BehaviorFunctions�CheckEntity�LogError�levelcommon:该实体不存在或被移除，无法检查距离。�levelId:�levelId�GetDistanceFromTarget�role�RemoveTips�leavingTips �distanceLimit�distanceWarningCurrentTime�GetFightFrame�distanceWarningEndTime       �warningSecond�math�ceil��    �AddTips�ChangeTitleTips�   �������� �  � DK  9 8 �	9 � �	9 8  ���L M 6  F� ��ipairs�areaLimitNameList�role�areaName�logicName�inArea�   �������� �  � DK  9 8 �	9 � �	9 8  ���L M 6  F� ��ipairs�areaLimitNameList�role�areaName�logicName�inArea�   �������� ���  � �  �   � ��  �  � �  ��RemoveAllLevelDelayCall�timeLimitTimerId�BehaviorFunctions�StopLevelTimer�   �������� �  �� 8  �G   �  �  �� DG ��levelId�RemoveAllLevelDelayCall��������� �  �  8 �� D B  � � � DG ��levelId�RemoveAllLevelDelayCall�timeLimitTimerId�BehaviorFunctions�StopLevelTimer�   �������� �  �  �  ��� � �  8  ��G ��timeLimitTimerId�timeLimitFinish�warningCountDownId�warningCountDownFinish���������  ��  �  ��  �
 ��  �ˁ � �	��  8 ��  � �� �		� 
�� ́ �  � �  8 ��  ��  � ��  � �DK 	B  8 �	�9 8 �	B  � � 
�	
 � DL M	 6  Ɓ ��role�BehaviorFunctions�GetCtrlEntity�next�levelCameraGroup�ipairs�CheckEntity�camEntity�followEntity�CameraEntityFollowTarget�rolesBindTransform�monsterList�currentGroupNum�list�id�wave�currentWave�engage�SetEntityValue�instanceId�battleTarget�   �������� �B  � ��  � 8  �� B�  8, ��  ��  �) �������  �˂ �
� ".� 
�� ��  � ��� 8 ���	�
�
����� ���� �� �  ��~��� � �  �

� � ��

�/�; �	 ��
����� �  	D�	� �  8 �� ��
 � 
� � ͂  �  � �  8 �� � � � �  5 �Ɓ ��formationDead�next�monsterList�ipairs�list�instanceId�isDead�infight �deadMonsterNum�totalDeadMonsterNum�monsterNum�topWave�currentWave�SummonMonster�showWaveTips�waveTips�BehaviorFunctions�AddTips��    �levelId�showEnemyRemainTips�ChangeSubTips�countTips�/�totalMonsterNum�   �������� 	�  � �DB  � � � �DK 9 8  ���L M 6  F� ��next�entityList�list�ipairs�instanceId�isDead�   �������� �� �����������