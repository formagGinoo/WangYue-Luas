LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π  F ��LevelBehavior10011002�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�Init�LateInit�Update�EnterTrigger�ExitTrigger�WorldInteractClick�CheckPlayerInRange�RogueGuidePointer�SummonMonster�KillAllMonsterChallenge�ReturnPosition�Die�Death�CheckPosInCam�  ���� �  G ��fight���������  �  R   �   �  N  H  �  ��     ��     ��������� ��    �  � �  ����	
��  R    �  �  �  �  R   ������ �  R   �������� ��!"��#$ �  �  %�  R   ����' &�  &�  (�)�*�+�,�  R    R   � �.�/�01�  R   � �.�/�01�  R   � �.�/�01�  R   � �.�/�01�  R   � �.�/�01�  R   � �.�/�01�  R   � �.�/�02�  -�3�4 �  R   �����   5�67�  ��me�instanceId�role�BehaviorFunctions�GetCtrlEntity�time �guide�guideEntity�guideDistance2       �guidePos�GuideTypeEnum�Police�FightEnum�GuideType�Rogue_Police�Challenge�Rogue_Challenge�Riddle�Rogue_Riddle�monsterStateEnum�Default        �Live       �Dead       �levelStateEnum�Start�Ongoing�LevelSuccece       �LevelFail       �LevelEnd       �levelState�levelFlagStateEnum�Showing�levelFlagState�levelFlag�levelFlagInteractionId�levelStartPos�levelStartPosIns�monsterList�state�wave�entityId�     ��     �monsterDead�monsterLimit�monsterBornDistance�levelRemoveDistance(       �   �������� ��  ���������� ڋ  � �   �  � �  �  �   � ��  �  � � 	� � 
  �  D� ��  �   8 ��  �  �  �   �  � ��    �	 ��  �   � ��  �  �  ��	D 8 ��  �  �  �   �  8J ��  � � �   � � �  � 
 �  �  8A ��   �  8 ��  � 胈   � � �  � 
  �  � !��   � �  � # � �  � % ��  &4 � �  � ' 8- ��   '�  8 ��� (�   &� )� �� *� &� � + 8 ��  � , �  �  �  -�   D� .� 8 � / 8 ��   ,�  �
 ��  � !���   � �  � 1 � �  �   8 ��  � 2 �  � �  � 3 � ��   /�  �	 ��  � 1 � �  �   8 ��  � 2 �  � �  � 4 � �  � 3 8 ��   3�  ����  ��time�BehaviorFunctions�GetFightFrame�role�GetCtrlEntity�guidePos�GetTerrainPositionP�position�positionId�logicName�RogueGuidePointer�guideDistance�GuideTypeEnum�Police�rogueEventId�GetRoguelikePointInfo�levelState�levelStateEnum�Default�levelStartPos�GetPositionP�levelFlagState�levelFlagStateEnum�levelFlag�CreateEntityl��    �x�y�z�levelId�Showing�Start�levelStartPosIns�ShowCommonTitle�发现城市威胁�ShowTipH�    �ChangeSubTipsDesc�monsterList�Ongoing�SummonMonster�monsterLimit�KillAllMonsterChallenge�LevelSuccece�GetDistanceFromPos�levelRemoveDistance�LevelFail�已清除城市威胁�HideTip�SetRoguelikeEventCompleteState�LevelEnd�RemoveLevel�   �������� 
�  � � � �  8 � �  �   � �D G ��role�levelFlag�levelFlagInteractionId�BehaviorFunctions�WorldInteractActive�WorldEnum�InteractType�Talk�开始挑战�   �������� �  � � � �  8 � �  DG ��role�levelFlag�BehaviorFunctions�WorldInteractRemove�levelFlagInteractionId�   �������� ��  9 8 �� �  � �� � � � �  �� � �� ��levelFlagInteractionId�levelFlag�levelState�levelStateEnum�Start�BehaviorFunctions�WorldInteractRemove�RemoveEntity�   �������� �  � D�  �  � �� 8 �  H �  �  H G ��BehaviorFunctions�GetPositionP�role�GetDistanceFromPos�levelStartPos�   �������� �  � D�  �  � �� 8 � B�  8 �  ��  ��	 � 
D
   �   ���  D 8	 � B  8 �  � DB  8 �  � D�  � D�G ��BehaviorFunctions�GetPositionP�role�GetDistanceFromPos�guide�guideEntity�CreateEntity�x�y�z�levelId�AddEntityGuidePointer�CheckEntity�RemoveEntity �RemoveEntityGuidePointer�   �������� ����    �˂ �
 � �  ��/�� ͂ �  : 8  ��� ��  �J   � DK� � �9 � � � �	 	D�� �	  
 ��������   �	�	 �	

�
  ��  �	
	
	�	 �			 	�	�	

 D		 	�	�	
�
 �
  D	�  �L M� 6  I� Ƃ ��ipairs�state�monsterStateEnum�Live�Default�math�random�monsterBornDistance�ReturnPosition      �?�Id�BehaviorFunctions�CreateEntity�entityId�x�y�z�levelId�DoLookAtTargetImmediately�role�SetEntityValue�haveWarn�   �������� 
�  � DK� � �	9�	 �  �  F� L M� 6    F� F� ��ipairs�state�monsterStateEnum�Dead�   �������� ��  R     R   �    � �J2   �   � D�  �  � � D� � 	 ��  � �	"	.		"	.	�	  	�	  
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
� � �B�  8 �  H 8  �� G ��BehaviorFunctions�GetPositionOffsetBySelf�GetPositionP�TableUtils�CopyTable�y�GetDistanceBetweenObstaclesAndPos�CheckObstaclesBetweenPos�CheckPosHeight�FightEnum�Layer�Terrain�Default�CheckPosIsInScreen�table�insert�math�random�   �������� ��   ��	 �9	 8 �� �	��� 	� �	  �	
�
 
� � �	 D� �
 �  Ɓ ��ipairs�monsterList�Id�monsterDead�BehaviorFunctions�ChangeSubTipsDescH�    �   �������� 
�B  8 �� �  �  �� �� 	 8 �� �		� � �  Ɓ ��levelState�levelStateEnum�LevelFail�ipairs�monsterList�Id�state�monsterStateEnum�Dead�   �������� �  ��D�� 8 �� ���?�� � �� ������ 8 ��  � �  ��  � � ��UtilsBase�WorldToUIPointBase�x�y�z�math�abs�   ���������