LuaT �

xV           (w@��� �Q     �   D        �  �  ���  �    ς    �   ς 	  � 
  ς   �   ς   �   ς   �   ς   �   ς   �   ς   �   ς   �	   ς	 F���RobotManager�BaseClass�table�insert�remove�sort�__init�StartFight�InitRobotBindArea�InitBindOccupancy�BindRobotTaskArea�UnBindRobotTaskArea�UpdateBindOccupancy�__delete�ShowRobotRadius�HideRobotRadius�DrawHalfSphereByCollider�LowUpdate�CheckChangeHeroList�CheckTriggerAreaRobot�CheckUnLoadRobot�CheckLoadRobot�SendMsgCallback�EnterFormation�ExitFormation�CheckFormationDeath�  ���� �       R      R      R     	
 �G ��fight�clientFight�robotCtrl�mod�RobotCtrl�loadRadiuObjs�bindArea�bindOccupancy�robotLoadState�RobotConfig�LoadState�Normal�changeFormation�   �������� ��   ��� �� � �� � �  ��robotCtrl�StartFight�InitRobotBindArea�InitBindOccupancy��������� ��   � ���  �D�   ��
 � �	�	�  8  �� �	
9�
 8  �� �B�  8  �� �� �	D� � �  Ɓ ��mod�TaskCtrl�GetAllTask�fight�GetFightMap�pairs�TaskConfig�GetTaskCfgByTaskIdShifted�taskId�stepId�map_id�inProgress�BindRobotTaskArea�   �������� ��   ��� �   �  �B�  8  �� �� �   �� ��robotCtrl�GetCurLoadTaskIdAndStepId�UpdateBindOccupancy��������� 
��  �  � �  8  �G  �   DB�  8  �� � ������	�  8  �G  R   	
� �� ��RobotConfig�GetDataTaskRobot�TaskConfig�GetTaskCfgByTaskIdShifted�mod�WorldMapCtrl�GetMapPositionConfigByPositionId�position_id�position�stepId�pos�taskRobotConfig�taskCfg�bindArea�   �������� ��  �  8  �� �  �9� 8  �G   �G ��bindArea�stepId ��������� ��   �  �B�  8  �Ɓ �  �  � �  8  �F�   ��/�D� ��������  �  �B�  8 � �F�  	�
��	
DB�  8  �ƃ �  B  � � D� �	  � 
�	   D���
; 8  ��    8  �F� �4 �	 9� 8  �F�  � DK �	�  � ��	�  8  ����9� 8  �F� L M 6   ��/�F� ��RobotConfig�GetDataTaskRobot�id�step�TaskConfig�GetTaskCfgByTaskIdShifted�bindOccupancy �mod�WorldMapCtrl�GetMapPositionConfigByPositionId�position_id�position�BehaviorFunctions�GetCtrlEntity�GetPositionP�UtilsBase�GetPosRadius�robot_radius       �robot_id_list�ipairs�   �������� ��    � ˀ
 �    �� ��  � �� ����  � �� ��� � �  �  ̀ �   �  �  � �  �  � ƀ ��pairs�loadRadiuObjs�loadObj�GameObject�Destroy�unLoadObj�TableUtils�ClearTable�bindArea�   �������� ��   �   8 ��� � ƀ �  � �  �D�   ��C � 	�	
��  8  ��> �	9�
 8  ��< � 
�
	��D�� ".� �  8 �� �  R   �� ��  8 �� ��  R   �� ���  � �� � ��
 �� �� 	5 ��   �  	
 D ��� �� � ���  �� ���  � �� � �� �� �� 	5 ��   �  	
 D ��� �� � ���  �� �D �  Ɓ ��DebugClientInvoke�ShowRobotRadius�HideRobotRadius�RobotConfig�GetAllDataTaskRobot�Fight�Instance�GetFightMap�pairs�TaskConfig�GetTaskCfgByTaskIdShifted�id�step�map_id�mod�WorldMapCtrl�GetMapPositionConfigByPositionId�position_id�position�robot_radius�loadRadiuObjs�loadObj�GameObject�CreatePrimitive�PrimitiveType�Sphere�name�_�DrawHalfSphereByCollider�UnityUtils�SetActive�unLoadObj�    �������� ��    � ˀ �    �� ��  8 �� ��  ���  8 �� ��  �� �	 �  �  ̀ �   ƀ ��pairs�loadRadiuObjs�loadObj�UnityUtils�SetActive�unLoadObj�   �������� 	� �  D � �D 	� 
0�
�
0�

0�
D� D�� ��transform�SetParent�clientFight�fightRoot�UnityUtils�SetLocalPosition�x�y�z�SetLocalScale       �GetComponent�Collider�enabled�   �������� ���  � �� � �  ��CheckChangeHeroList�CheckTriggerAreaRobot��������� 	��     8  ��  �  � ��� ���  �� ��  �J � DB�  8 � 4 � 8  �G I� � 	 
�  DG ��changeFormation�fight�playerManager�GetPlayer�GetCtrlEntityObject�FormationConfig�FormationState�stateComponent�IsState�mod�FormationCtrl�UpdateFightFormation�   �������� ��    �� 8  ��  �  ��� �   8 �B  8 ��� �   ��  ��� �� ��robotLoadState�RobotConfig�LoadState�Normal�robotCtrl�GetCurLoadTaskIdAndStepId�CheckUnLoadRobot�CheckLoadRobot�   �������� ��  �  8 ��   � DG B  8 �=~ 8  �G  D� �  � �	  D��	 ���
�

� 8 ��   �   DG ��bindArea�ExitFormation�taskRobotConfig�robot_radius�BehaviorFunctions�GetCtrlEntity�GetPositionP�UtilsBase�GetPosRadius�pos       �    �������� ��    �   8  �ƀ �  � �  � D� ����  � �  � �  �  �� B�  8  � 	 � 8  � 	 � � �  � � 	
�  D����
: � �� 
��DF� ��next�bindArea�BehaviorFunctions�GetCtrlEntity�GetPositionP�mod�TaskCtrl�GetGuideTaskId�pairs�UtilsBase�GetPosRadius�pos�taskRobotConfig�robot_radius       �EnterFormation�id�step�   �������� �� ��  � �  B  � ��� �   ��� ��  8 �B  � �: �  �  8 �9 8  �   �� �   �� ��robotLoadState�RobotConfig�LoadState�Normal�bindOccupancy�UnBindRobotTaskArea�CheckFormationDeath�changeFormation�UpdateBindOccupancy�   �������� �� ��  � ���   �� ��robotLoadState�RobotConfig�LoadState�Loading�robotCtrl�EnterTaskRobotsRadius�   �������� �   �  �  �� D �  � DG ��robotLoadState�RobotConfig�LoadState�UnLoading�CheckFormationDeath�robotCtrl�SendMsgRobotExitFormation�   �������� ��   � ��� �DB  �  ����� ��fight�playerManager�GetPlayer�CheckIsPlayerFormationAllDead�RevivePlayerFormation����������