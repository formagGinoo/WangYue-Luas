LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �   F ��LevelBehavior101060801�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�GetStorys�NeedBlackCurtain�Init�Update�CastSkill�CreateWall�RemoveWall�DisablePlayerInput�Death�StoryEndEvent�StoryStartEvent�WeakGuide�RemoveWeakGuide�  ���� �  G ��fight���������  �  R   �   �  N  H  �  ���     z�     ���������  �   R   H  �  ����������  �   ���F  G  ���������� ��  � �   ��  R    R   ��	�
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
 R   ��	�
��  �  R   ��!��"#��$%��&'  �  R    R   �)�  �"�  (�  R   ��!��+#��,% *�  R    R   �.� *�!�/0�12�  -�3%�  R    R   � �N �  4�5�6�7�  R    R   �.�/9�1:�  8�;<�7�6�=	�  ��role�BehaviorFunctions�GetCtrlEntity�missionState        �weakGuide�Id�      �state�Describe�推动摇杆进行移动�count�      �长按进入跑步状态�      �连续点击2次跳跃可二段跳�      �长按在墙面上奔跑�      �点击按钮使用普通攻击�      �普攻积攒日相能量�      �消耗日相能量释放技能�      �点击按钮释放绝技�      �      �在受到红眼攻击前，按下闪避键将进入异质空间�      �当敌人释放黄圈攻击时，按下跳跃键可触发跳跃反击。�dialogStateEnum�Default�NotPlaying       �Playing       �PlayOver       �dialogList�    �monsterStateEnum�Live�Dead�monsterList �bp�Task1010608Mb1�entityId��     �monLev�waveList�monsterDead�time�timeStart�blockInf�Task1010608Wall1z�     �gate1EcoIdaz���  �jumpCounterGuide�   �������� ҋ  � �   �  � �  �  �  8' ��  �  	�  � �  � 
  � �  �  �  � �   � ˀ � �  �  ��  ̀ �   �  � � ��   � �  � � ���   � �  � � ��	   � �  � � ���	   � �  � � ��
   � �  � � ���
   � �  � � ��   � �  � � ���   � �� ��  � � 8K ��  �  ��  �  �� D� ! "D � #�DK  � $�	�	%� � D� $�	 
'� $��(  ��  �	 )
 *D�&
� $�	 ,
-�+
� �	. $

&� �� �	/ $

&�   �� �	/ $

&�� ����� �	/ $

&� ����L M 6  � 3 ��  4�  $&�� D '����  �������� � )D
 6 .�  $&D 7� 6 D 8� 6 $&�� D :+� ;�<9� 8 � =� :��&D :� ;�<+ >�  ?@D�A�  � B � ��  � C $&�� � �   8 ��  � D $&�� � �  E� F 8 ��    G� � � � 8 ��  � 4 � $ � �  � 4 � $��&$ � �  � � ���	   � �  I� � +� F � ��� J� I��&� �  I� ��+K�EK�L�  � L 8' ��  � M N� �   8# ��  � O 6� �  � D $&�$ � �  � D �$ � �  � P�( ���� �  � � ��   � �  � � ���   � �  � � ��	   � �  � � ���	   � �  � � ��
   � �  � � ���
   � �  � � ��   � �  � � ���   � �� �R�  � R � ��  #� �  ���  #��
 � �	S $

&��K ���� $�	�	+ ,
T�
 8 ��/�9 8  ��U� � �  �  � � 8 ��  � V� �� W� "� �  � X Y� ��Z � � S� D<K � �� �/  ��-   � \��(  �� �D�]�  � � � ��  � ^�( � ƀ ��time�BehaviorFunctions�GetFightFrame�role�GetCtrlEntity�missionState�SetGuideShowState�FightEnum�GuideType�Task�SetTipsGuideState�SetJoyMoveEnable�ipairs�KeyEvent�ForbidKey�SetFightMainNodeVisible�Joystick�I�J�O�K�L�Core�PowerGroup       �GetTerrainPositionP�tp_Sword��     �Logic10020001_6�InMapTransport�x�y�z�CreateWall�blockInf�waveList�monsterList�bp�Id�CreateEntity�entityId�levelId�monLev�state�monsterStateEnum�Live�DoLookAtTargetImmediately�SetEntityValue�haveWarn�ExitFightRange�targetMaxRange�AddDelayCallByFrame�AddBuff�5    �levelCam�CameraEntityFollowTarget�CameraEntityLockTarget�HitCase�dialogList�dialogStateEnum�Playing�StartStoryDialog�DoSetEntityState�EntityState�FightIdle������ @������@�HasBuffKind�RemoveBuff�jumpCounterGuide�timeStart��    �weakGuide�WeakGuideffffff@�CheckKeyDown�Jump�RemoveEntity�ShowTip�    333333@�CheckEntity�Dead       �HideTip�RemoveWall�GetEcoEntityByEcoId�gate1EcoId �Remove�SendTaskProgress       �RemoveLevel�   �������� ��  � 8 �� ���  � �< � �� �� � ��jumpCounterGuide�monsterList�Ide�l    �timeStart�BehaviorFunctions�GetFightFrame�   �������� �  � DK  � �� D� �	� � � 
�	  �
� �	 D
�
 
��� D 
�	
�		DL M 6  F� ��ipairs�BehaviorFunctions�GetTerrainPositionP�bp��     �Logic10020001_6�GetTerrainRotationP�Id�CreateEntity�entityId�x�y�z�levelId�DoMagic�5    �SetEntityEuler�   �������� �  � DK� <� � � �D< � �� �	�����L M� 6  F� ��ipairs�Id �BehaviorFunctions�CheckEntity�SetEntityAttr�   �������� ��  ���   � ��  �ˁ �  �	  �  �� ́ �  � ��  � �  ��  �ˁ �  �	  �  �� ́ �  B  8 ��  �� ���   �� ��  �� ���   �Ɓ ��BehaviorFunctions�CancelJoystick�ipairs�FightEnum�KeyEvent�ForbidKey�SetJoyMoveEnable�role�SetFightMainNodeVisible�PanelParent�   �������� �B  � ��   �� � �	��  � �� �	�� � �  �� � �� ��� �	 ��
 ��   �ˁ �� 	 � �� �		� �	��� 	� �	 � �� ́ �  � ���  8  ��Ɓ ��ipairs�monsterList�BehaviorFunctions�CheckEntity�Id�RemoveEntity�RemoveWall�blockInf�HideTip�RemoveLevel�    �state�monsterStateEnum�Dead�monsterDead�ChangeTitleTipsDesc�missionState       �   �������� 	�  � DK� �  � � �  8  �� ��	L M� 6  F� ��ipairs�dialogList�Id�missionState������@�state�dialogStateEnum�PlayOver�currentDialog �   �������� �G ���������� �  �   �� � �	� ���� �  ��  � � �  < � �� �  � � ��Ɓ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�state�PlayGuide�   �������� 
��    � ˀ � �� ���  ̀ �   ƀ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�   ���������