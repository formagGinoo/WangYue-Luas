LuaT �

xV           (w@��� �Q     �    D      R   ���	�
��������    R   �  �  �  �  �  �  �  � 
  �  �  !�  �  "�  �  #�  �  $�  �  %�  �  &�  �  '     �    (   π   )   �   *   π  +   �   ,   π  -   �   .   π  /   �   0   π  1   �   2   π  3   �   4   π  5   �   6   π  7   �   8   π  9   � 	  :   π	  ;   � 
     π
  <   �   =   π  >   �   ?   π  @   �   A   π  B   �   C   π  D   �   E   π  FF ��TaskConditionManager�BaseClass�EventAndTimerKeeper�TaskConditionEnum�CheckPosition       �EnterArea       �ExitArea       �StoryDialogEnd       �MessageEnd       �GuideEnd       �CheckEntityState       �FinishDialogOption       �FinishLevel	       �BargainEnd
       �WaitTime       �CheckCondition       �TaskConditionTrans�check_position�enter_area�exit_area�storydialog_end�message_end�check_condition�guide_end�finish_dialog_option�finish_level�bargain_end�wait_time�__init�BindListener�RemoveListener�OnTaskSystemReBulid�AddTask�BindCondition�CheckConditionIsDone�StartFight�OnFightStart�PlayerUpdate�Update�LowUpdate�SubConditionPass�__delete�CheckPosition�EnterArea�ExitArea�StoryDialogEnd�GetStoryEndCondition�CheckDialogFinish�CheckEcoEntityState�CheckLevelFinish�BargainEnd�DayNightTimeChanged�CheckInTimeArea�IsInTimeArea�RemoveTimeAera�AddSystemConditionListener�CheckAllSystemCondition�CheckSystemCondition�OnTaskFinish�  ���� �    R      R      R      R    ���	  R    
 R   � �� � D� �� � D� �� � D � DG ��fight�checkSubTasks�checkTasks�notInTimeArea�checkInTimeArea�mapCfg �curCtrlEntity�work�waiting�TaskCondition_CWB�TaskConditionEnum�EnterArea�ToFunc�ExitArea�FinishDialogOption�CheckDialogFinish�BindListener�   �������� Ք�  � ��  D �  ��  � ��  D �  ��  � �� � D �  ��  � �� � D �  ��  � �� � D �  ��  � �
�  D �  ��  � �� � D �  ��  � ��  D �  ��  � ��  D �  ��  � �� � D �  ��  � �� � D �  ��  � �� �	 D �  �  ��AddEventListener�EventName�AddTask�ToFunc�EnterMap�PlayerUpdate�EnterLogicArea�EnterArea�ExitLogicArea�ExitArea�EntityHit�StoryDialogEnd�BargainEnd�FinishLevel�CheckLevelFinish�DayNightTimeChanged�TaskSystemReBulid�OnTaskSystemReBulid�TaskFinish�OnTaskFinish�   �������� Ք�  � ��  D �  ��  � ��  D �  ��  � �� � D �  ��  � �� � D �  ��  � �� � D �  ��  � �
�  D �  ��  � �� � D �  ��  � ��  D �  ��  � ��  D �  ��  � �� � D �  ��  � �� � D �  ��  � �� �	 D �  �  ��RemoveEventListener�EventName�AddTask�ToFunc�EnterMap�PlayerUpdate�EnterLogicArea�EnterArea�ExitLogicArea�ExitArea�EntityHit�StoryDialogEnd�BargainEnd�FinishLevel�CheckLevelFinish�DayNightTimeChanged�TaskSystemReBulid�OnTaskSystemReBulid�TaskFinish�OnTaskFinish�   �������� ��   �  � �   �  � �   �  � �  ��TableUtils�ClearTable�checkSubTasks�notInTimeArea�checkInTimeArea�   �������� �B�  8  �� �    8 �� � � R   ���� � ���� ��  8 �� 	  DG ��work�table�insert�waiting�taskId�inProgress�mod�TaskCtrl�GetTask�BindCondition�   �������� �  ��DB�  8  �� �  8  �� �� �  8  �8 � B�  � � �  R    B�  8 � �  R    � 	B  8 � 
� � �D �D�  ����   �� �  �� � DB  � � �	�   �D� � � � � 8 ��   �D�   �D�  �� DG ��mod�TaskCtrl�GetTaskConfig�taskId�stepId�goal�TaskConditionTrans�checkSubTasks�DebugConfig�OpenTaskLog�LogInfo�TaskTAG�BindCondition�DayNightMgr�Instance�GetTime�SetDayNightTime�TaskConfig�GetTaskActionableTimeArea�next�checkInTimeArea�CheckInTimeArea �notInTimeArea�TaskConditionEnum�CheckCondition�AddSystemConditionListener�CheckSystemCondition�CheckConditionIsDone�   �������� ��    � �  � ��  �  �   ƀ ��pairs�TaskCondition_CWB�   �������� ��   ���  �  D   G ��fight�GetFightMap�mapCfg�mod�WorldMapCtrl�GetMapConfig�checkEntity�checkSubTasks�   �������� �� �  �  �  8 ��   � �  �� ���  �  �   �  �  � ƀ ��work�waiting�ipairs�AddTask�taskId�inProgress�TableUtils�ClearTable�   �������� ��  � ��� ���   �  ��curCtrlEntity�fight�playerManager�GetPlayer�GetCtrlEntityObject��������� ���  � �  ��CheckAllSystemCondition��������� ��     8  ��  �   � � �   DG ��curCtrlEntity�transformComponent�position�CheckPosition��������� ��  ��  8 ��  ��  8  �� � ��  8  �� � ���� �  8  �G   ��   D �  � �� DG ��checkSubTasks�notInTimeArea�mod�TaskCtrl�GetTask �RemoveTimeAera�SendTaskProgress�stepId�   �������� ���  � �  ��RemoveListener��������� �  B  8 � �  DB�  8  �F�  B  � � � �B�  8  �F�  �  �DK   �  �	 �D��
 8  �8 �� �		�  �
�  8  �8 �	�#
.
0
�	����
"
.�	����
"
.� ���
; � ��   � � DL M 6  F� ��mapCfg�next�checkSubTasks�TaskConditionEnum�CheckPosition�pairs�id�tonumber�BehaviorFunctions�GetTerrainPositionP�level_id�x       �y�z�SubConditionPass�   �������� �  B  � �  � �B�  8  �F�   � � �   �DK�  	 � ���� �
�
��  � �� 	  � � DL M�	 6  F�  �   �DK  	 � ��  8
 �� 
� �
D�� 8  �8 ��
9 � ��
�� 8  �� ��� 	�  �� ��L M 6  F� ��checkSubTasks�TaskConditionEnum�EnterArea�pairs�fight�sceneAreaManager�CheckEntityInArea�curCtrlEntity�instanceId�SubConditionPass�mapCfg�id�tonumber�   �������� �  B  � �  � �B�  8  �F�   � � �   �DK�  	 � ���� �
�
�  � �� 	  � � DL M�	 6  F�  �   �DK  	 � ��  8
 �� 
� �
D�� 8  �8 ��
9 � ��
�� 8  �� ��� 	�  �� ��L M 6  F� ��checkSubTasks�TaskConditionEnum�ExitArea�pairs�fight�sceneAreaManager�CheckEntityInArea�curCtrlEntity�instanceId�SubConditionPass�mapCfg�id�tonumber�   �������� Ҏ    8  �Ɓ ���O  �   ��  8 ��   � ��˂ �
  �D�  8 ������  	 � � � D� ͂ �  �   ��  � ��   � ��� �
  �D� ��� 8  �� � ��  �J� 	9	 � ������  
	 �
 � � D	8  �I � � �  Ƃ ��checkSubTasks�TaskConditionEnum�StoryDialogEnd�pairs�tonumber�SubConditionPass�FinishDialogOption�   ����  �	     ~/ �
   	   =  ���G  �� ������������ �  B�  �  �  F�   � �B  � � �   �DK   � �� 	 �  ��  Ƅ L M 6     � �B  8 � �   �DK  	 � 
� �
D9 8 �    8 ��  R   � ��L M	 6    � F�   F� F� ��checkSubTasks�TaskConditionEnum�StoryDialogEnd�pairs�tonumber�FinishDialogOption�   �������� ��    �   8  �ƀ �    � �� ˀ �  �D� � 
�	 DB  �	 ��  
 �  8  �� �� �	��
�
�� 8 ��   � � D����  ̀ �   ƀ ��checkSubTasks�TaskConditionEnum�FinishDialogOption�pairs�tonumber�StoryConfig�GetStoryConfig�next�mod�StoryCtrl�GetSaveDialog�group_id�SubConditionPass�   �������� �  B  � �  � �B�  8  �F�  �   �DK   � �� 	 � ��� �  �� ��L M 6  F� ��checkSubTasks�TaskConditionEnum�MessageEnd�pairs�tonumber�SubConditionPass�   �������� ��   �   � ��    �   8  �ƀ �    � �� � 
 �  �D� � 
�	   DB  � ��� �  �� ���  �  �   ƀ ��checkSubTasks�TaskConditionEnum�CheckEntityState�pairs�tonumber�BehaviorFunctions�CheckEcoEntityState�SubConditionPass�   �������� �  B  � �  � �B�  8  �F�  �   �DK   � �� � ��   � � DL M 6  F� ��checkSubTasks�TaskConditionEnum�FinishLevel�pairs�tonumber�SubConditionPass�   �������� ��  �  � ��   �  8  �Ƃ �   � ��˂
 �
  �D�  �  �  ��� 8  �� 9 8 �� � ��  	 � �	 	D� ͂ �  Ƃ ��checkSubTasks�TaskConditionEnum�BargainEnd�pairs�tonumber�true�false�SubConditionPass�   �������� �  �   ��  8 ��  �� �� �	  
 �C� ���� � �  � �  � ��  �  8  �Ƃ �  � ��˂
 �
  �D0� 	�
���	 �#� ; � ��  	 � �	 	D� ͂ �  B  �  ��� �Ƃ ��next�checkInTimeArea�pairs�CheckInTimeArea�checkSubTasks�TaskConditionEnum�WaitTime�tonumber<       �mod�TaskCtrl�GetDayNightTime�SubConditionPass�CheckConditionIsDone�   �������� Ë  �  � � �D  �   �� �� 8 ��� �  �  �  �� � �  �   9 8  ��   � 	�  8 �B  8 � 	
�  � D� � 	
�  � D � 
�   D  � F� F� ��TaskConfig�GetTaskActionableTimeArea�DayNightMgr�Instance�GetTime�pairs�startTime�endTime�notInTimeArea�Fight�entityManager�npcEntityManager�BindTask�UnBindTaskOnShow�EventMgr�Fire�EventName�EnterTaskTimeArea�   �������� �  B  � � 3 H   H G ��checkInTimeArea�notInTimeArea��������� �  � �G ��checkInTimeArea �notInTimeArea��������� 
��   �  8  �� � � �  �� � � D G ��checkSubTasks�TaskConditionEnum�CheckCondition�tonumber�fight�conditionManager�AddListener�ToFunc�CheckAllSystemCondition�   �������� ��    �   8  �ƀ �    � �� ˀ � � �  DB  8 ��   � � D����  ̀	 �   ƀ ��checkSubTasks�TaskConditionEnum�CheckCondition�pairs�tonumber�fight�conditionManager�CheckConditionByConfig�SubConditionPass�   �������� 	��  � �  DB  � ��   � � DG ��tonumber�fight�conditionManager�CheckConditionByConfig�SubConditionPass�TaskConditionEnum�CheckCondition�   �������� 	��  ����   �  8  �G B�  8  �G � � B  8 � B�  8  �G �   D �G ��mod�TaskCtrl�GetTaskConfig�goal�TaskConditionTrans�checkSubTasks�RemoveTimeAera �   ���������