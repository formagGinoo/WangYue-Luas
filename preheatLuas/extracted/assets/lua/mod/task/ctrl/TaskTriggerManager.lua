LuaT �

xV           (w@��� �Q     �    D      R   ���	�
�����    R   �  �  �  �  �  �  �  � 
 �  �  �  �  �  �  �  �  �  �       �        π   !   �   "   π  #   �   $   π  %   �   &   π  '   �   (   π  )   �   *   π  +   �   ,   π  -   �   .   π  /   �   0   π  1   � 	  2   π	  3   � 
  4   π
  5   �   6   π  7   �   8   π  9   �   :   π  ;   �   <   π  =   �   >F ��TaskTriggerManager�BaseClass�EventAndTimerKeeper�TaskTriggerEnum�PlayStoryDialog       �CreateLevel       �Transport       �Message       �Duplicate       �Teach       �PlayerLookAtPos       �PLayerLookAtEco       �PlayGuide	       �TaskTriggerTrans�play_storydialog�create_level�transport�start_message�create_duplicate�start_teach�player_lookatpos�player_lookateco�play_guide�__init�BindTriggerFuncs�BindListener�RemoveListener�__delete�DoTrigger�DoTaskClickTrigger�Update�LowUpdate�OnPlayStoryDialog�OnCreateLevel�OnTransport�OnMessage�OnCretaeDupLicate�OnTeach�OnPlayerLookAtPos�CheckPosDistance�OnPlayerLookAtEco�OnPlayGuide�OnGuideFinish�CheckEcoDistance�SetCamOrientation�TryRemoveCamera�RemoveCamera�StartFight�OnFightStart�OnFinishLevel�OnRemoveLevel�RefreshLoadLevel�GetTaskLevelParam�OnTaskFinish�  ���� ���  ��� ������  R    ��	�
��  ��  R    �  R    ���  R    � ��BindTriggerFuncs�BindListener�teachId �guideId�curTaskId�curTaskStep�curParams�role�curEcoEntity�startPlayerLookAtPos�startPlayerLookAtEco�removeEntity�fight�taskManager�work�waiting�doTriggerMap�timer�camTimer�loadLevelList��������� ��   R     �    � � �    � � �    � � �    � 	� �    
� � �    � � �    � � �    � � �    � � �  ��triggerFuncs�TaskTriggerEnum�PlayStoryDialog�OnPlayStoryDialog�CreateLevel�OnCreateLevel�Transport�OnTransport�Message�OnMessage�Duplicate�OnCretaeDupLicate�Teach�OnTeach�PlayerLookAtPos�OnPlayerLookAtPos�PLayerLookAtEco�OnPlayerLookAtEco�PlayGuide�OnPlayGuide�   �������� ���  � ��  D �  �  � ��� ��  D �  �  � ��� �	�  D �  �  � ��� ��  D �  �  � ��� ��  D �  �  ��AddEventListener�EventName�DoTaskClickTrigger�ToFunc�EventMgr�Instance�AddListener�AddTask�DoTrigger�GuideFinish�OnGuideFinish�FinishLevel�OnFinishLevel�RemoveLevel�OnRemoveLevel�   �������� ���  � ��  D �  �  � ��� ��  D �  �  � ��� �	�  D �  �  � ��� ��  D �  �  � ��� ��  D �  �  ��RemoveEventListener�EventName�DoTaskClickTrigger�ToFunc�EventMgr�Instance�RemoveListener�AddTask�DoTrigger�GuideFinish�OnGuideFinish�FinishLevel�OnFinishLevel�RemoveLevel�OnRemoveLevel�   �������� ���  � �  �  � �� � �  ��RemoveCamera�TableUtils�ClearTable�doTriggerMap�RemoveListener�   �������� ��    8 �� � � R   ���� B�  8  �� � ���� �  8  �G  �	�
DB�  8  �� � ���
�  � ��   ��  8  �� ��  8 �� �  8  �� � �  8  �G  �D��� 8  �� � �	
  8 �� �  R   �
� �	

�	
�  8  �� �  
��   �
�� �	

��
� �	�  8 �� �	   �
��  �� ��work�table�insert�waiting�taskId�inProgress�mod�TaskCtrl�GetTask�GetTaskConfig�stepId�taskManager�CheckIsInTimeArea�next�trigger�TaskTriggerTrans�fight�GetFightMap�map_id�doTriggerMap�Log�DebugConfig�TaskTAG�task trigger�triggerFuncs�   �������� �  �  DB�  8  �� �  8  �� � ���  8  �G B  8 � 	�DB�  8  �G  
��B�  8  �� � ��  � �� �   ���	  �  �� ��mod�TaskCtrl�GetTask�inProgress�TaskConfig�GetTaskCfgByTaskIdShifted�taskId�stepId�click_trigger�next�TaskTriggerTrans�triggerFuncs�   �������� ��  ���������� ��   �   �  ��� � �  �   �  ��� � �  �   �  ��� � �  ��startPlayerLookAtPos�CheckPosDistance�startPlayerLookAtEco�CheckEcoDistance�removeEntity�TryRemoveCamera��������� 
�B�  8  �� �  ��  8 �� ���� �� �  ��  ���  ��  ���   � � � ��taskManager�taskInCurtain�LuaTimerManager�Instance�AddTimer      �?�SetTaskInCurtain�PlayStory�tonumber�   ����  �     �  �D G  ��CurtainManager�Instance�FadeOut�   ������������ ��  ���9� 8  �G  �  DB  8  �G B�  8  �� �   � B  � � 	� �	
� �   � D�   D� ��	� �� ��fight�GetFightMap�map_id�mod�TaskCtrl�GetExitTask�tonumber�DebugConfig�OpenTaskLog�LogInfo�TaskTAG�TaskTriggerManager:OnCreateLevel�GetTaskLevelParam�taskManager�AddTaskLevel�   �������� ���B  � ��  � �B  �  �  8  �G   �  �   DB  �  �  8  �� B  �) �� ��	�B  �  �  8  �G  
�
D�
D�
��	�
�
#.0
�����
".�����
".����; 8 � � D�� 8  �    B  � �� ���  � � �
D� �  �
	  �  �  �
	�	D8 �� � � D�
��� ��mod�WorldMapCtrl�GetMapPositionConfigByPositionId�fight�GetFightMap�playerManager�GetPlayer�GetCtrlEntityObject�transformComponent�GetPosition�x       �y�z�tonumber�BehaviorFunctions�CheckCtrlDrive�GetDrivingEntity�instanceId�SetPlayerDrive�WorldCtrl�InMapTransport�Transport�   �������� �B�  � ��  � � �� � � � D � � ��Log�Error�触发短信失败,缺少对应的配置信息messageId = %s�BehaviorFunctions�StartMessage�tonumber�   �������� �B�  � ��  � � �� � � � D � � ��Log�Error�副本关卡创建失败,缺少对应的配置信息duplicateId= %s�BehaviorFunctions�CreateDuplicate�tonumber�   �������� 
�B�  � ��  � � ��   8 �� � 8  ��  � � � D � � ��Log�Error�教学创建失败,缺少对应的配置信息teachId= %s�teachId�BehaviorFunctions�ShowGuideImageTips�tonumber�   �������� �   � G ��curTaskId�curTaskStep�startPlayerLookAtPos�curParams��������� ̋  � �   �   �  � �D� � �  � � �D� �  �   � �  D� �	  � ��� �  �> � � 
�   � D� �	胈  

�

� �� �   �   �� � �� ���� �  �  � �F� ��role�BehaviorFunctions�GetCtrlEntity�tonumber�curParams�GetTerrainPositionP�GetPositionP�GetDistanceFromPos�empty�CreateEntity�x�y�z�SetCamOrientation�timer�LuaTimerManager�Instance�AddTimer�startPlayerLookAtPos�   ����  �     �  D �G  ��fight�entityManager�RemoveEntity�empty �  ������������ � �D    � G ��ecoEntityId�tonumber�curTaskId�curTaskStep�startPlayerLookAtEco�curParams�   �������� �  �D�  �<� 8  �    � ���  �   �  DB  �  � 	8 ���
� �� ��tonumber�true�fight�clientFight�guideManager�PlayGuideGroup�GuideUtil�GuideCallType�Task�guideId�SaveTaskGuide�   �������� ��  �  8 ��  �� 8  �� � � ��guideId ��������� ��  � �   �  �  �  �   �  � �D�  � � D� �  � 	�   D:� �  �� 8 ��� 
�   �   ��� ��role�BehaviorFunctions�GetCtrlEntity�curEcoEntity�GetEcoEntityByEcoId�ecoEntityId�tonumber�curParams�GetPositionP�GetDistanceFromPos�SetCamOrientation�startPlayerLookAtEco�   �������� �� �  �  � �  � � ���� �	�
�� �  � �B  � �� ����� �  � �@ 8 �� ���� �  �  � 8  ��ƃ ��levelCam�BehaviorFunctions�CreateEntity�camentity�GetEntity�CameraManager�Instance�GetCamera�FightEnum�CameraState�Operating�targetGroup�DoLookAtTargetImmediately�clientEntity�clientCameraComponent�cinemachineCamera�m_Follow�Transform�CameraEntityLockTarget�camTimer�LuaTimerManager�AddTimer�removeEntity�   ����  �     �  D ��G  ��fight�entityManager�RemoveEntity�levelCam �camentity�  ������������ ��   � ���  � �   8 �� DG  � �	�
��D3 B  8  �� �� �� ��mod�TaskCtrl�CheckTaskStepIsFinish�curTaskId�curTaskStep�RemoveCamera�UtilsBase�IsNull�camentity�clientEntity�clientCameraComponent�cinemachineCamera�m_LookAt�   �������� ��   �   � ��  �   � �  �   � ��  �  � �  �   � ��  � ��� � ��  	�   � ��  � ��� 	� �	�
� ���  ��levelCam�BehaviorFunctions�RemoveEntity�empty�timer�LuaTimerManager�Instance�RemoveTimer �camTimer�camentity�removeEntity�   �������� ��  ���������� �� �  �  �  8 ��   � �  �� ���  �  �   �  �  � ƀ ��work�waiting�ipairs�DoTrigger�taskId�inProgress�TableUtils�ClearTable�   �������� �  �G ��loadLevelList ��������� 	�  B  8 � � �� �  D D G ��loadLevelList�LuaTimerManager�Instance�AddTimer�������?�ToFunc�RefreshLoadLevel�   �������� ��   � ���  � DK� 9� 8  �� �� �	��		� �
 ��  8  �8 � 
� DB�  8 � 
B  � � ��   D 
�  
�   R   � ��� R    
� �� DL M� 6  F� ��Fight�Instance�GetFightMap�pairs�loadLevelList�taskConfig�map_id�mod�TaskCtrl�CheckTaskStepIsFinish�id�step�BehaviorFunctions�CheckLevelIsCreate�DebugConfig�TaskTAG�LogInfo�TaskTriggerManager AddLevel�AddLevel�src�LevelManager�Src�Task�info�   �������� �  R   � � �D��� R    	
� R   �N �� �  ��� � ���B�  8  ����� 
�
  �   D
�   ��  	 ��8	 �� ��� 8 �� ������	����H � ��trigger�tonumber�levelId�taskId�id�step�param�src�LevelManager�Src�Task�info�TableUtils�GetTabelLen�mod�WorldMapCtrl�GetMapPositionConfigByPositionId�levelPosition�loadRadius�loadHeight�CheckDistance�task_position�position_id,      �       �   �������� �� �� ��startPlayerLookAtEco�startPlayerLookAtPos����������