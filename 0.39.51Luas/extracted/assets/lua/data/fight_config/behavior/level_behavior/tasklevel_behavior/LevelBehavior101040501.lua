LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π     �      π     � 	     π	     � 
     π
     �   F ��LevelBehavior101040501�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�GetStorys�Init�Update�CreatMonster�DisablePlayerInput�LevelLookAtPos�SkillGuide�CastSkill�FinishSkill�BreakSkill�ClearSkill�OnGuideImageTips�OnGuideFinish�CreateWall�RemoveWall�WeakGuide�RemoveWeakGuide�Die�Death�StoryEndEvent�StoryStartEvent�  ���� �  G ��fight���������  �  R   �   �  N  H  �  �Ȼ     z�     ���������  �  R   �   N  H  �  �u�    ��������� ��  � �   ��  R    R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
�  R   ��	�
� 	 �  R   ������ ��!" �   R    #�  R   ����%��&  $�  R    R   �(� $��)*�+,�  R   �(� $��)-�+,�  R   �(� $��).�+,�  R   �(� $��)/�+,�  '�0�  R    R   ���N �  R   �� ��N �  1�2�3�4�  R    R   �(�)6�+7�  5�89�:	�;	�<	�=	�>(�?	�@	�  ��role�BehaviorFunctions�GetCtrlEntity�missionState        �weakGuide�Id�      �state�Describe�推动摇杆进行移动�      �长按进入跑步状态�      �连续点击2次跳跃可二段跳�      �长按在墙面上奔跑�      �点击按钮使用普通攻击�      �普攻积攒日相能量�      �消耗日相能量释放技能�      �点击按钮释放绝技�      �dialogStateEnum�Default�NotPlaying       �Playing       �PlayOver       �dialogList�monsterStateEnum�Live�Dead�monsterList �bp�Task1010405Mb1�entityIdȻ     �Task1010405Mb2�Task1010405Mb3�Task1010405Mb4�monLev�waveList�monsterDead�time�timeStart�blockInf�Task1010405Wall1z�     �watchPos�watchPosition2�juejiWeakGuide�juejiImagGuide�firstJueji�imagTipsFinish�value�guideSwitch�firstJuejiEnd�   �������� ��  � �   �  �   �  �  �   ��Y�� �� 8 ��  �   ��Y���� �� �  �  �- ��  � � ���   � �� 
� � �  � � � � �  ��  �� � D
  ���  �������� � D
  �  D �  D� �6��  � D� �6��  � D �  D  ��  �� D� � ����� �    �� � � �   ��"�  � " 8 ��   � � � � 8 ��  � � � � �  $�  ��  D� %� �D� �	��   %��D �  D �&�  � & 8 ��   � � � � 8 ��� �    � �  � ' ()*�  � �  � + ���� �-�  � � �J ��  .� / 8 ��  0� 4 � 1  �� � �	2 3

� 
2� 3��DB  � � 
4� 3���D��ۅ; �
 �� �5 3������� � � 6� 3�� 3��J�D�.7� � �  8 ��  � 8:�� � � � ��  9� � :� / � ��  � � ���   � �  0� 4 � 1  �� � �	<  � 3��� �� � �  � �<  �  � ��� >� 9���� 9���:78 ��  � 8:�� �  8 ��  9� � :� 7 �  ��� ?� �  0� 4 � 1  �ˁ � 3�	�	: @
A��
 8  �8 �� 8 �� �	  � 	�� ?�� ́	 �  �  � � � ��  0� 4 � 1  ��	 � 3�	�	: @
A��
 8  �� �� � �� �	  � 	�� ?��B� �
 �  �  C� / � ��  � � 8 ��   � � � � 8 ��� ?� �  � D��� �  0� 4 � 1  �ˁ � �	E 3

�� �� ́ �  � �  � �C7�  � � �3 ��   � � � � �0 ��  � F� �  � G � � �� �  � � ��H 8& ��  � 2 � �   8" ��  �  I� � �  ��  �� � D
 J ���  �������� � D
 K � K JD � K D� �'��  � KD� �'��  � JD L�   D � ��􁁂�D�  �  � �   � �M�  � � � ��  � N � ƀ ��role�BehaviorFunctions�GetCtrlEntity�time�GetEntityFrame�GetEntityAttrVal�SetEntityAttr�missionState�SetFightMainNodeVisible�I�CreateWall�blockInf�GetTerrainPositionP�watchPosition4��     �Logic10020001_6�empty2�CreateEntity�x�y�z�levelId�levelCam2�CameraEntityFollowTarget�CameraEntityLockTarget�Id�AddDelayCallByFrame�RemoveEntity�timeStart�tp_101040502�Transport�DisablePlayerInput�ActiveSceneObj�101040501Airwallffffff @�Task1010405Mb2�DoLookAtPositionImmediately�CreatMonster      !@�SetGuideShowState�FightEnum�GuideType�Task�ShowTipu�    	       �juejiWeakGuide�waveList�ipairs�CheckEntity�monsterList�GetEntityAttrValueRatio�GetEntityElementStateAccumulationRatio�SetEntityElementStateAccumulation�GetPlayerAttrVal�weakGuide�state�L�AddBuff��    �WeakGuide�RemoveWeakGuide�monsterStateEnum�Dead
       �juejiImagGuide�ShowGuideImageTips�RemoveBuff�HideTip�SendTaskProgress �watchPos�empty�levelCam�DoLookAtTargetImmediately       �RemoveLevel�   �������� �  � �� �� D�  � � � � �  � 	�  
��  � � � �  � ��
�D  � ��
 �  D  � ���
 ��1�D  � �� ��1�DG ��BehaviorFunctions�GetTerrainPositionP�monsterList�bp��     �Logic10020001_6�GetTerrainRotationP�Id�CreateEntity�entityId�x�y�z�levelId�monLev�state�monsterStateEnum�Live�SetEntityEuler�SetEntityValue�haveWarn�ExitFightRange�targetMaxRange�   �������� ��  ���   � ��  �ˁ �  �	  �  �� ́ �  � ��  � �  ��  �ˁ �  �	  �  �� ́ �  B  8 ��  �� ���   �� ��  �� ���   �Ɓ ��BehaviorFunctions�CancelJoystick�ipairs�FightEnum�KeyEvent�ForbidKey�SetJoyMoveEnable�role�SetFightMainNodeVisible�PanelParent�   �������� �  �  � D�  �胈  ��  �
 �  �  �  ��������  �
 	�  �
 � ��  8 ��  � 	�   �8 ��  � 	� ��  � 	� ��� �   �  � 	�  ��� �   �  � 	��� �   �  � �� ��BehaviorFunctions�GetTerrainPositionP��     �empty2�CreateEntity�x�y�z�levelId�levelCam2�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�SetEntityShowState�RemoveEntity�   �������� Ƌ   �  �X��   � �X�D��� 8 �� ��� 8 �� ���� ����� � ���8 ������  8 �� ��� 8 �� ���� ����� � ���8	 ������ � �� ��� 8 �� ���� ����� � ���� ��BehaviorFunctions�GetEntityAttrValueRatio�role�weakGuide�state�WeakGuide�Id�   �������� ��  �  8 �< 8  ��� ��role[F     �firstJueji��������� ��  �  8 �< 8  ��� ��role[F     �firstJuejiEnd��������� ��  �  8 �< 8  ��� ��role[F     �firstJuejiEnd��������� ��  �  8 �< 8  ��� ��role[F     �firstJuejiEnd��������� ��   8 �< 8  ��� �4N      �imagTipsFinish��������� ��  ���  �
 �� � �� �� �4 �   �˂ � � 
�� �� ͂ �  Ɓ ��weakGuide�Id�BehaviorFunctions�RemoveBuff�role��    �waveList�ipairs�monsterList�   �������� �  � DK  � �� D� �	� � � 
�	  �
� �	 D
�
 
��� D 
�	
�		DL M 6  F� ��ipairs�BehaviorFunctions�GetTerrainPositionP�bp��     �Logic10020001_6�GetTerrainRotationP�Id�CreateEntity�entityId�x�y�z�levelId�DoMagic�5    �SetEntityEuler�   �������� �  � DK� <� � � �D< � �� �	�����L M� 6  F� ��ipairs�Id �BehaviorFunctions�CheckEntity�SetEntityAttr�   �������� �  �   �� � �	� ���� �  ��  � � �  < � �� �  � � ��Ɓ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�state�PlayGuide�   �������� 
��    � ˀ � �� ���  ̀ �   ƀ ��ipairs�weakGuide�BehaviorFunctions�FinishGuide�Id�   �������� ��   �ˁ �9	 �	 �� �		� �� � �� �	��� 	� �		� �� �	 � �� ́ �  � ��9 8 ��� �� � ���Ɓ ��ipairs�monsterList�Id�state�monsterStateEnum�Dead�missionState�monsterDead�BehaviorFunctions�RemoveBuff��    �ChangeTitleTipsDescu�    �firstJuejiEnd�           �   �������� �B  8 ��   �� � �	��  � �� �	�� � �  �� ��� � �� �	�� �
� �   �� � �� ���  8  ��Ɓ ��ipairs�monsterList�BehaviorFunctions�CheckEntity�Id�RemoveEntity�RemoveWeakGuide�RemoveWall�blockInf�HideTip�ActiveSceneObj�101040501Airwall�levelId�RemoveLevelu�    �missionState       �   �������� 	�  � DK� �  � � ��L M� 6  F� ��ipairs�dialogList�Id�state�dialogStateEnum�PlayOver�currentDialog �   �������� �G �����������