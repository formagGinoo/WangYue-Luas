LuaT �

xV           (w@��� �Q     �    D        �   O  � �   O�  � �   O � �   O� � �   O � 	�   O� � 
�   O � �   O� � �   O � �   O� � �   O � �   O� � �   O � �  O� � �  O � �  O� � �  O � �  O� � �  O	 � �  O�	 � �  O
 � �  O�
 � �  O � �  O� � ƀ��DeathComponent�SimpleBaseClass�PoolBaseClass�FightEnum�DeathCondition�__init�Init�BindJudgeListener�BeforeUpdate�Update�AfterUpdate�ClearJudgeList�GetJudgeCondition�GetJudgeInfo�IsInJudge�Drown�TerrainDeath�OnCache�DeathComponent�RemoveAllListeners�__cache�__delete�AddToJudgeList�RemoveInJudgeList�RemoveJudgeList�HasJudgeConditions�RemoveSurfaceList�Revive�AfterDeathTransport�SetIgnoreDeath�  ���� �� ��   R    �  R    � �  � �  �  ��judgeList �judgeConditions�judgeSurfaceList�judgeFuncs�Drown�Terrain�TerrainDeath�  �������� �   ���� ��� �� 	�� ���� 
� ��fight�entity�isDeath�config�GetComponentConfig�FightEnum�ComponentType�Death�BindJudgeListener�deathRayHeight�collistionComponent�height333333�?�   �������� ��    � �  �   8 ��  R    � � R    
�
�
 	�
�
�

�
�	�  �  �   ƀ ��pairs�config�DeathList�judgeConditions�DeathReason�deathReason�FightEnum�DeathCondition2Reason�judgeFunc�judgeFuncs�deathConditions�deathCondition�deathTime�DeathTime�   �������� ��  ���������� ��   �   � ��    � �   8 ��  �   8  �ƀ �    � ˀ �   ���  8 �� ���� 	�	
 
�� ��� 	�	
 
�� ���� �	�	���  ��  ̀ �   �  �   �  ��� � ƀ ��judgeList�next�ignoreDeath�pairs�judgeFunc�deathConditions�EventMgr�Instance�Fire�EventName�EntityWillDie�entity�instanceId�FireEntityEvent�stateComponent�SetState�FightEnum�EntityState�Death�deathReason�isDeath�ClearJudgeList�   �������� ��  ���������� ��   �  � �   �  � �  ��TableUtils�ClearTable�judgeList�judgeSurfaceList�   �������� �  H G ��judgeConditions��������� �  H G ��judgeList��������� �  B  � �  < 8  �    H G ��judgeList ��������� � B  8 � � ����#�� � �  �  H B  8 � �	 
DB  � � B  � � � 
��D? �  ��  �   H G ��DrownHeight�entity�transformComponent�position�moveComponent�GetSurfaceOfWater�y�CheckPower�stateComponent�IsState�FightEnum�EntityState�Swim�attrComponent�BehaviorFunctions�GetPlayerAttrVal�PlayerAttr�CurStaminaValue�   �������� �  � �  8 �� �4 � �ʂ ��	�	� 8 ���	� ���	 9	 8 ��� � ��  � �	 �  �  ��	�
� ����$.���� � ��; �  ��  � �� � ���� �D� �  � ����  �   � ����  � �� �
8 �� ��
	� ���:� 8  ��  �  � �  � � ��judgeList�Terrain�checkConfig�extraParam�layer�TerrainDeathList�TerrainDeath�RemoveInJudgeList�checkTime        �FightUtil�deltaTimeSecond�entity�timeComponent�GetTimeScale�TerrainDeathTime�TerrainDeathHeight�transformComponent�GetPosition�judgeSurfaceList�deathReason�CS�PhysicsTerrain�LayerCheck�deathRayHeight�y�     �������� ��   �   � ��  �   � �  �   � ��  �  � �  �   � ��  �  � �  � ���    � �  ��judgeList�TableUtils�ClearTable�judeSurfaceList�judgeConditions�fight�objectPool�Cache�DeathComponent�   �������� ��  ���������� ���  � �  ��RemoveAllListeners��������� ���  � �  ��RemoveAllListeners��������� ��  �� �� 8  �� �   8 ��  R    � �  � �� �  8  �� �  	� �D�� ��
� ��entity�stateComponent�backstage�FightEnum�Backstage�Foreground�judgeList�judgeConditions�UtilsBase�copytab�extraParam�   �������� ��    D�   DG ��RemoveJudgeList�RemoveSurfaceList��������� �  B  � �  B�  8  �G   �G ��judgeList ��������� �  B  � � B  � �  B  �  �  H   H G ��judgeList�judgeConditions��������� �  B  � �  B�  8  �G   �G ��judgeSurfaceList ��������� �� �  ��isDeath��������� �   � ���  � � �  � ��� �D��� 	�
�  � �4 � �� ��	��	� ���  8 �  �� 8  �ɂ ���� ��� ��������DO  ��� �	�
 D@ � �	�
  D�� 8 ��  D�
���  �� �����   �	


�  
!� "#0#�$�#�#%#0#�"�#�#$#0#�%�#�#	  �	 D
F� ��CurtainManager�Instance�FadeIn���Q��?�fight�playerManager�GetPlayer�GetEntityList�GetEntityQTEIndex�entity�instanceId�stateComponent�IsState�FightEnum�EntityState�Death�GetSyncPosition�GetFightMap�BehaviorFunctions�SetBodyDamping�GetQTEEntityObject�attrComponent�GetValue�EntityAttrsConfig�AttrType�Life�deathComponent�SetIgnoreDeath�fight�entityManager�CallBehaviorFun�ChangeRole�BehaviorFunctions�Transport�pos_x-C��6?�pos_y�pos_z�   ���� �B�  8  �   � � ��� � ��  � �  ��� �	 D����	�
��� 8 ����������������  �� 	 � �  �� 8 ���� ��  D� ��fight�LuaTimerManager�Instance�AddTimer�playerManager�GetPlayer�GetQTEEntityObject�attrComponent�GetValue�EntityAttrsConfig�AttrType�Life�deathComponent�Revive�stateComponent�SetState�FightEnum�EntityState�Idle�SetIgnoreDeath�       ����  �     �  �D     �� � �� D G  ��CurtainManager�Instance�FadeOut�BehaviorFunctions�SetBodyDamping      �?�  ���������������� �  G ��ignoreDeath����������