LuaT �

xV           (w@��� �Q     �    D       �      �  � �   �  	  ρ  
  �   ρ   �   ρ   �   ρ   �   ρ   �   ρ   �   ρ   �   ρ   �   ρ   �	   ρ	   �
   ρ
   �   ρ  F���TaskListView�BaseClass�BaseView�NotClear�Config�DataTaskType�Find�DataTaskTab�__init�__delete�__CacheObject�__BindListener�OnCloseClick�CommonButtonClick�GotoButtonClick�__Create�__Show�GetGmData�OnSelectToggle�Select�GetTypeList�GetType�OpenTaskList�SortNode�GetNodeWeight�GetNodeTree�GetDeepth�TaskSelect�RefreshTaskBtn�GetPreNode�AddTask�GMExec�  ���� �  �  D�  R      R      R    �	 
� �� � � D G ��model�SetAsset�AssetConfig�debug_task_list�curSelect        �toggleObjMap�TaskTypeList�taskList�gmex�EventMgr�Instance�AddListener�EventName�AddTask�ToFunc�   �������� ��   � ��� ��  D �  �  ��EventMgr�Instance�RemoveListener�EventName�AddTask�ToFunc�   �������� ��  ���������� ��   � ���� � � �  �  � ���� � � �  �  � ���� � � �  �� � 	�
� � D �  �  ��CloseBtn_btn�onClick�AddListener�ToFunc�OnCloseClick�FinishBtn_Btn_btn�CommonButtonClick�GotoBtn_Btn_btn�GotoButtonClick�EventName�GetGMData�GetGmData�   �������� ��   � � ��� �  ��TaskListManager�Instance�model�CloseMainUI�   �������� �     � � � DG  ��  � �� � �	  R   � 
�  � � � � 
�  � � � � ����    � ���  � �� ��
 �  R    
�  � D D  �  �   D�
  � D 
�  ��	D D  
�  ��	D D  �  �   D�� �� ��selectData�LogInfo�先获取server gm data�mod�GmCtrl�serverGmData�selectTypeIndex�TaskTypeList�task_open_type_and_finish_pre_type�config�table�insert�tostring�type�sec_type�ExecGmCommand�selectTaskConfig�TaskConfig�GetNodeOfTask�id�task_node_change_and_finish_pre_node�task_step_change�TableUtils�ClearTable�step�OnCloseClick�   �������� ��   R     B�  � ��  �Ɓ � �� 	�
D � DB  � � ��� �  R    �  �D D  �  �D D  �  �   D �  
�� �D D B  �o � ��D�   R   � �  �   � � � ����    � �� �  � �	� � � � � � #�$  �� �  � 
� � � �  � 
%� � � ����    � �� �  � �	 ��%� � �  R     � ' (�˄ � �  ����� � ���%%�� �  �� ̈́	 �  �)*� �  ���ʅ �+ ),<- �	 �,� �/��0�	 1
�	 �  .� �/��2�	 .�	+
�
�  8 �34 @ �  ��38  �� �  )B  8 �B  8 ��
4
5�
6 �  �� 	 )D D � � )B  � ��  �
 � /�2 )�			D� �  � �	 �	 )
	�
	� � �45�68 � )B  � ��������� �  �� 	 )D D  :� � D�   � < = >� @�A� ?� C���D���	 ��� E�
# �	 �  BF� ��selectData�LogInfo�先获取server gm data�mod�GmCtrl�serverGmData�Fight�Instance�taskManager�taskTriggerManager�RemoveListener�EventMgr�Fire�EventName�PauseTipQueue�selectTypeIndex�TaskTypeList�task_open_type_and_finish_pre_type�config�table�insert�tostring�type�sec_type�ExecGmCommand�string�format�跳转%s-%s�selectTaskConfig�TaskConfig�GetNodeOfTask�id�task_node_change_and_finish_pre_node�切换node %s�task_step_change�TableUtils�ClearTable�step�切换task:%s step:%s�pairs�taskList�positionId �position_id�goal�check_position�mapCfg�WorldMapCtrl�GetMapConfig�tonumber�GetMapPositionConfigByPositionId�task_position�x�y�z�Transport positionId:%s�Transport map:%s, posName:%s belong:%s�Transport map:%s�concat�,�posx�posy�posz�checkTimeStep�TimeUtils�GetCurTimestamp�checkTimer�LuaTimerManager�AddTimer�ToFunc�GMExec�   �������� ��  ���������� ��   � ��� �� �  � �  ��mod�GmCtrl�RequestGmList�SetNotifyBlurBack�SystemBlur1�StaticBlur2�   �������� ��   ���  � �  	 � �  �� �� 8 ��� ��  
�O  ���	�  ��	�	
��	��	�	
��	� ��	����� � ��� ���� ����
��
� ��  �  �  �  �   ƀ ��ButtonPart�SetActive�pairs�task_type�PopUITmpObject�TabBtn�NavTabsContent�transform�object�TabBtn_tog�onValueChanged�RemoveAllListeners�AddListener�isOn�task_tabicon��LoadSingleIcon�UnSelectIcon�task_tab_icon�SelectedIcon�UnSelectTabText_txt�text�name�SelectedTabText_txt�toggleObjMap�    ���� ��   � �  � �   � �  � B   � ��  ��� � �  ��UtilsUI�SetActive�UnSelect�Selected�OnSelectToggle�       ������������ �  9 8  �F�  �  D � DK �  � DL M 6   � D 	�  D 
  �   D�   �ˁ �� �  ��	�	� ��
 ��	
�
D	�
  D	�
  D	
�
O  D 
�  	 D�  � ́ �  Ɓ ��lastSelect�ButtonPart�SetActive�pairs�TaskTypeList�PushUITmpObject�TaskItem�TableUtils�ClearTable�TypeList�curSelect�GetTypeList�PopUITmpObject�TypeContent_rect�config�Name_txt�text�sec_type_subhead�Detail_txt�string�format�type:%s,sec_type:%s�type�sec_type�TaskItemBtn_btn�onClick�RemoveAllListeners�Select�TraceImg�AddListener�table�insert�   ����  �	   �  	 D 	   � 	 D G  ��OpenTaskList�Select�    ������������ �  R        � DK� ��� 8  �    DL M� 6  � DF� ��selectData�selectTypeIndex�ipairs�TaskTypeList�Select�SetActive�RefreshTaskBtn�   �������� �	  �   R   �  �˂ �� �
 �� DK� 		�	  
 D	L M� 6  � ͂ �  F� Ƃ ��task_type�pairs�GetType�table�insert�    �������� �  R   �  	 �� �� 8 �� �	  � �� � �  F� Ɓ ��pairs�type�table�insert�     �������� �  �  D�  R    � DK	   R   �� �	  
 ��  
 �˅ � � 	 �	 �� ͅ �  L M
 6   � D  R   �   �˂  �
� ͂ �  �  	�� �� 
�� 
�� � �  � � 	��  R   �   D�   �˃	 � ��� �DK 
 
�
  R   D
L M 6  � ̓
 �  �   ��  � �  D� �  � �ʇ �	 �	 
 �
 �	� � � D
�
 �
�
! "#� �   D�
�
%���  �
�
&�
'��(�
�
 �
��)�   �
*�  D&'�+O  D � 	 R   ,D�	  � � �! �  � -��.ƃ ��TaskList�SetActive�nodes�pairs�GetPreNode�table�insert�sort       �taskList�PushUITmpObject�TaskItem�item�TableUtils�ClearTable�SortNode�Config�DataTaskNode�Find�tasks�nodeId�taskId�ipairs�mod�TaskCtrl�GetTaskStepCount�TaskConfig�GetTaskCfgByTaskId�PopUITmpObject�TaskContent_rect�Name_txt�text�task_goal�Detail_txt�string�format�node:%s,task:%s,step:%s�Select�TaskItemBtn_btn�onClick�RemoveAllListeners�CheckTaskStepIsFinish�TraceImg�AddListener�config�TaskList_sRect�verticalNormalizedPosition�   ����  �	   �  	 D G  ��TaskSelect�   ������������ �  R   �  R     � DK�  
�   DL M� 6    � DK �   D�  ��   �
 D � 
L M 6   � O  DƁ F� ��pairs�table�insert�GetNodeWeight�LogInfo�string�format�nodeId:%s,depth:%s�sort�   ���� �	   �  �:� 8  �    H G �� ������������ � R    �� � ��� � � �  � ��nodeId�GetNodeTree�GetDeepth��������� �  ��  R   � �� � � �� �ˁ � �	� R   ��� ́ �  � �ˁ �� 	� �� ́ �  Ɓ ��Config�DataTaskNode�Find�nodeId�child�pre_node�pairs�table�insert�GetNodeTree�   �������� ��   �  ���F� 4 = �  � �F� ��� �� �� � �:	 8  � 	 � � �  ��/�Ɓ Ɓ � �child�pairs�GetDeepth�   �������� �   � DK �
�9 8 �
	�	9� 8  �    DL M	 6   
�  D� DF� ��selectData�selectTaskConfig�ipairs�taskList�item�Select�SetActive�config�id�step�ButtonPart�RefreshTaskBtn�   �������� ��   ��� � 8  ��  �  � �    8  ��  �  ���  � �  � �   �  ��  ���  � �   � ��  � 	�   � ��  ��
�  ���  � �  ��ButtonPart�SetActive�selectData �GotoBtn�selectTypeIndex�FinishBtn_StartText_txt�text�开启指定章节�selectTaskConfig�切换任务节点��������� ��  �  � �� ���4 @ 8 � �DK �  	 � DL M 6  F� ��table�insert�Config�DataTaskNode�Find�pre_node�pairs�GetPreNode�   �������� ��  � �   �  ��checkTimeStep�TimeUtils�GetCurTimestamp�   �������� 
ދ   � �  �/�: 8* � � D D �	 
D � ������ ��   D ��~�� �D �D� �������  �� � � �� ���� �  8 �� �  � �� �  8 �� � �  � �� ��� � !�"�� �#��� $�G ��TimeUtils�GetCurTimestamp�checkTimeStep�LogInfo�3秒没有收到新的任务信息认为已经收取完所有的任务了�BehaviorFunctions�StoryPauseDialog�LuaTimerManager�Instance�RemoveTimer�checkTimer�selectData�mod�TaskCtrl�GetTaskAddRecord�selectTaskConfig�id�currentStep�taskAddRecord�Fight�taskManager�taskTriggerManager�BindListener�WorldMapCtrl�GetCurMap�DoTrigger�positionId�posx�posy�posz�Transport�EventMgr�Fire�EventName�ResumeTipQueue�StoryResumeDialog�OnCloseClick�   ���������