LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π  F ��LevelBehavior104040112�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�Init�Update�CreateMonster�SetCombatTarget�CreateEntityId�SetLevelCamera�Death�RemoveEntity�  ���� �  G ��fight���������  �  R   �   �  N  H  �  ��     �     ��������� �� ��  R   ������	 �  R    R   � ������  R   � ������  
�  R    R   � ������  R   � ������  R   � ������  �  R    R   ����  R   ����  R   ����  R   ����  R   ����  R   ����  R   ����  R   � ���  R   �!��� 	 R   �"��� 
 R   �#���  R   �$���  �%�  R    '()�� '(*�� '(+�� &�,-�  / .�  ��missionState        �role �monsterStateEnum�Default�Live       �Dead       �monsterList1�state�bornPos�Monster01�entityId�     �id�lev�Monster02�monsterList2�Monster04�Monster05�Monster06�entityList1�tengman1�     �tengman2�tengman3�tengman4�tengman5�tengman6�tengman7�tengman8�tengman9�tengman10�tengman11�tengman12�thornNum�monsterLevelBias�FightEnum�EntityNpcTag�Monster�Elite�Boss�transPos�rolePos�lookAtPos�mil�   �������� 	�  � �   �  �  8 ��  �   � ��    B  � � �  � D�  � � �  D�   	�
�D�  �  � �  �  �� � �� � � �� ��
 � �� � � �� � � ��  � � � ��� � � �� �� � �� � � ��   � � 
 �  � 8 �� !� � �� � �� �# �� �$��%�  �  �   ƀ ��role�BehaviorFunctions�GetCtrlEntity�missionState�transPos�logicName�GetTerrainPositionP�mapId�levelId�InMapTransport�x�y�z�StartStoryDialoga�3    �ShowTip��    �消灭区域内所有噬脉生物和荆棘�CreateMonster�monsterList1�SetLevelCamera�Monster01�SetCombatTarget�CreateEntityId�entityList1       �monsterList2�Monster04       �ipairs�state�monsterStateEnum�Dead�thornNum)�3    �FinishLevel�HideTip
       �   �������� �  � DK  �D� �	  � 
"	
�
�� 8 �@ 8  ��
� �� 	� ��  ��	 �
 	 
 D�
 ��
 D �L M 6  F� ��ipairs�BehaviorFunctions�GetTagByEntityId�entityId�GetEcoEntityLevel�monsterLevelBias�lev�GetTerrainPositionP�bornPos�levelId�id�CreateEntity�x�y�z�DoLookAtTargetImmediately�role�state�monsterStateEnum�Live�   �������� �  � DK� � �	9	 � � �� �  D � � 	D � ���DL M� 6  F� ��ipairs�state�monsterStateEnum�Live�BehaviorFunctions�SetEntityValue�id�haveWarn�battleTarget�role�targetMaxRange�   �������� �  � DK�  ��	 D� 
��  ��  �  D�
� �	��� 	L M� 6  F� ��ipairs�BehaviorFunctions�GetTerrainPositionP�bornPos�levelId�id�CreateEntityByPosition�entityId�thornNum�   �������� 	�  �  D�  �胈  ������ �  ���� �  �	 � 
� ��  � � ��  � 
� ��� ��  �  � ��� ��  �  � �� ��BehaviorFunctions�GetTerrainPositionP�levelId�empty�CreateEntity�x�y�z�levelCam�CameraEntityFollowTarget�role�CameraTarget�CameraEntityLockTarget�DoLookAtTargetImmediately�AddDelayCallByFrame�RemoveEntity�   �������� ̋   �� �� 	 8 �� �		� � �  �   �� �� 	 8 �� �		� � �  � �� 8	 �� 4 �    �� �
 �� �  �ƅ 8 �� 8  ��� � �  � �� � �� 4 �    �˂ �
 �� �  �ƅ � �� � �� 	�
� � ��� ͂ �  Ɓ ��ipairs�monsterList1�id�state�monsterStateEnum�Dead�monsterList2�missionState       �BehaviorFunctions�ChangeTitleTipsDesc��    �消灭区域内剩余的荆棘       �   �������� 	�  � DK� �  � � ~/� L M� 6   = 8 � � � DF� ��ipairs�entityList1�id�thornNum�BehaviorFunctions�ChangeTitleTipsDesc��    �消灭区域内剩余的噬脉生物�   ���������