LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π     �      π     � 	     π	     � 
     π
     �   F ��LevelBehavior101040101�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�GetStorys�Init�Update�DisablePlayerInput�LevelLookAtPos�SkillGuide�CreateWall�RemoveWall�OnGuideImageTips�WeakGuide�RemoveWeakGuide�OnGuideFinish�RemoveEntity�__delete�Death�StoryEndEvent�StoryStartEvent�PathFindingBegin�PathFindingEnd�Assignment�ReturnPosition�  ���� �  G ��fight���������  �  R   �   �  � N  H  �  �Ȼ     ʻ     z�     ���������  �   R   H  �  ���������� ��  � �   ��  R    R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
��  R   ��	�
�� 	 R   ��	�
�� 
 �  R   ���� !��"#��$% �  R    R   �'� � �  R   �(� � �  &�  R   ����*!��+# )�  R    R   �-� )��./�01�  R   �-� )��.2�01�  ,�  R    R   � �N �  3�4�5�6�  R    R   �-�.8�09�  7�:;�<!�=-�  ��role�BehaviorFunctions�GetCtrlEntity�missionState        �weakGuide�Id�      �state�Describe�推动摇杆进行移动�count�      �长按进入跑步状态�      �连续点击2次跳跃可二段跳�      �长按在墙面上奔跑�      �点击按钮使用普通攻击�      �普攻积攒日相能量�      �消耗日相能量释放技能�      �点击按钮释放绝技�      �      �在受到红眼攻击前，按下闪避键将进入异质空间�dialogStateEnum�Default�NotPlaying       �Playing       �PlayOver       �dialogList�    i�    �monsterStateEnum�Live�Dead�monsterList �bp�Task1010401Mb1�entityIdȻ     �Task1010401Mb2�waveList�monsterDead�time�timeStart�blockInf�Task1010401Wall1z�     �watchPos�watchPosition1�monLev�creatPos�   �������� ˋ  � �   �  �   �  �  �  � ��� � � ��  � � �* ��  	  8 ��  � 
  ��  � �   8% ��   � ������ DB  �  �� �  � 	� ��� ��   � � ��	 � �� �    � �  � � ��   � �  � � ���   � �  � � ��   � �  � � ���   � �  �   ����� �   �����D ��   � D �    !"D�#�  �  �1 ��  $ %� � * � &� (� &�	�	)  � 	�* 	+� 	�, � 	 -D�'� &� /0�.� �1 &'�  �� �2 &'��   �� �2 &'� �c��� �2 &'�� �c��� �6 &'�  �� �7 &'�  �	8�	9  ����� � � � �:  � &��'� ��  � + �   �� ��   � � � � �=�  � < � ��  � > &'��   � �� ��   � � �  � �A�  � @ 8	 ��  � :  �  ! � �  � :  � &��'! � �  � C�� �D�  � D 8 ��  � E  FG� �   8 ��� �    � �  � H &'�! � �  � H  �! � �I�  � I � ��  � J K'� �  K�  LM� .�N�  � O 8 ��� �    � �  � � ��(   � �Q�  � � � ��  � R S� �   � ��  � T S� �  � � ��   � �  � � ���   � �  � � ��   � �  � U  �X����� �  � � ��+   � �� �  � W+ � �  � X  YZ�  � �  � [. ���� �]�  � � �4 ��  � ^  ��Y�� �� 8 ��  � U  ��Y���� �� �  K� � . L_�  � ��  � `  �X�� ���; 8 � a.<b �
 �� c a'D :�    �! D :�   &'�! D a�.d a.B  � �� eD8 � a.<b � �� c a'D a�.d�  %� 4 � $  �ˁ	 � &�	�	. /
f��
 �  �Ƅ � �� � �� �	  � g	�� e��h� ́
 �  �  � � 85 ��   g� � � � 82 ��  � i� �  � � '��j �* ��  � R '� �   �& ��  � k l��6  �  (��  �*+�, � D
 n (���  �������� � D
 o p� o nD q� o 'D� �'��  T� oD� �'��  T� nD� �'��  J� K��'D 1�   'D U� ��'􁁂�D�  � � �   � �rƀ ��role�BehaviorFunctions�GetCtrlEntity�time�GetEntityFrame�missionState�CreateWall�blockInf       �creatPos�CheckEntityInArea�Task1010401Area01�Logic10020001_6�ReturnPosition������@      �?�SetTipsGuideState�AddDelayCallByFrame�Assignment������ @�DisablePlayerInput�SetFightMainNodeVisible�Joystick�J�O�K�GetPositionOffsetBySelf�LevelLookAtPos�ActiveSceneObj�101040101Airwall�levelId�DoSetEntityState�FightEnum�EntityState�FightIdle       �ipairs�waveList�monsterList�Id�CreateEntity�entityId�x�y�z�monLev�state�monsterStateEnum�Live�DoLookAtTargetImmediately�SetEntityValue�haveWarn�ExitFightRange�targetMaxRange�ShowEntityLifeBarElementBar�EnableEntityElementStateRuning�ElementState�Accumulation�AddBuff�5    ffffff@������@�CastSkillByTarget.Z]          @333333@��    �ShowGuideImageTips������@�CheckKeyDown�KeyEvent�Dodge�RemoveBuff������@�StartStoryDialog�dialogList�dialogStateEnum�Playingffffff@333333@�I       �CheckEntity�levelCam2�RemoveEntity�SetEntityAttr�PowerGroup�StopSetFightMainNodeVisible�SetGuideShowState�GuideType�Task�ShowTip�           �GetEntityAttrVal�PlayOver�GetEntityAttrValueRatio�weakGuide�WeakGuide�RemoveWeakGuide�Dead�timeStart       �HideTip �GetTerrainPositionP�watchPos��     �empty�levelCam�CameraEntityFollowTarget�CameraEntityLockTarget       �   �������� ��  ���   � ��  �ˁ �  �	  �  �� ́ �  � ��  � �  ��  �ˁ �  �	  �  �� ́ �  B  8 ��  �� ���   �� ��  �� ���   �Ɓ ��BehaviorFunctions�CancelJoystick�ipairs�FightEnum�KeyEvent�ForbidKey�SetJoyMoveEnable�role�SetFightMainNodeVisible�PanelParent�   �������� ǋ �胈  ��  �
  � �  �  ��������  �
 � � 	�  �B  8 �� �
 � 	  �8 �� �
 � 	�� � �  �� �
 ��� �  � �	 �  ��� �  � �	 ��� �  � �	  �� ��empty2�BehaviorFunctions�CreateEntity�x�y�z�levelId�levelCam2�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�SetEntityShowState�RemoveEntity�   �������� Ƌ   �  �X��   � �X�D��� 8 �� ��� 8 �� ���� ����� � ���8 ������  8 �� ��� 8 �� ���� ����� � ���8	 ������ � �� ��� 8 �� ���� ����� � ���� ��BehaviorFunctions�GetEntityAttrValueRatio�role�weakGuide�state�WeakGuide�Id�   �������� �  � DK  � �� D� �	� � � 
�	  �
� �	 D
�
 
��� D 
�	
�		DL M 6  F� ��ipairs�BehaviorFunctions�GetTerrainPositionP�bp��     �Logic10020001_6�GetTerrainRotationP�Id�CreateEntity�entityId�x�y�z�levelId�DoMagic�5    �SetEntityEuler�   �������� �  � DK� <� � � �D< � �� �	�����L M� 6  F� ��ipairs�Id �BehaviorFunctions�CheckEntity�SetEntityAttr�   �������� ��   8 �< 8 ��� �    �� �� ���   �� �
�� � ��� � �
�	�� �
��
� �9N      �DisablePlayerInput�BehaviorFunctions�SetFightMainNodeVisible�K�weakGuide�state�WeakGuide�Id�   �������� �  �   �� � �	� ���� �  ��  � � �  < � �� �  � � ��Ɓ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�state�PlayGuide�   �������� 
��    � ˀ � �� ���  ̀ �   ƀ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�   �������� ��  ���  � �� � �� ��  8 �� � �� �� � �� �� � �� �� ��weakGuide�Id�BehaviorFunctions�HasBuffKind�monsterList�5    �RemoveBuff��    �role�   �������� �G ���������� ��  ���������� �B  � ��   �� � �	��  � �� �	�� � �  �� � ��� �� �	�� �
� �   �� � ��
 ��   �ˁ �� 	 � �� �		� �	��� 	� �	
 � �� ́ �  Ɓ ��ipairs�monsterList�BehaviorFunctions�CheckEntity�Id�RemoveEntity�RemoveWall�blockInf�RemoveWeakGuide�HideTip�ActiveSceneObj�101040101Airwall�levelId�RemoveLevel�    �state�monsterStateEnum�Dead�monsterDead�ChangeTitleTipsDesc�    �   �������� �  � DK �  8 � �  � � ��  �� �D �  D ��D �� D �  8 � 	�� � �  D� ��L M 6  F� ��ipairs�dialogList�Id�BehaviorFunctions�SendTaskProgress�    �SetTipsGuideState�ShowGuideImageTips�RemoveLevel�SetFightMainNodeVisible�I�missionState333333@�state�dialogStateEnum�PlayOver�currentDialog �   �������� �G ���������� ��  �  � � �  �   D< � ��  �  � ��	��  � 8 �� 
� ��  � � ��BehaviorFunctions�GetTerrainPositionP��     �Logic10020001_6�SetPathFollowPos�DoSetMoveType�FightEnum�EntityMoveSubState�Run�LogError�无路径可供寻路�   �������� ��  �  � ��  �  ��  �  � ���� ��BehaviorFunctions�DoLookAtTargetImmediately�role�ClearPathFinding�DoSetEntityState�FightEnum�EntityState�Idle�   �������� � � ���������� �  R   �    � �J+   �   � D�  �  � � D� � 	 ��  � �	"	.		"	.	�	  	�	  
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
   �	  � ��	  �	 
 �	�	� � ��
 	�

�
9� �  �=
 8 ��
 �
  � �
I�+ 4 � �� � �� �
0�H � �  8 ��  � 8  �� � ��BehaviorFunctions�GetPositionOffsetBySelf�GetPositionP�TableUtils�CopyTable�y�GetDistanceBetweenObstaclesAndPos�CheckObstaclesBetweenPos�CheckPosHeight�FightEnum�Layer�Terrain�table�insert�math�ceil       �   ���������