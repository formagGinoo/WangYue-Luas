LuaT �

xV           (w@��� 
�Q     �    D          �  � �  � �� R   ��  �� N � R    ��  �  R   ��  �� N � R   	 ��	 �   �  	  τ  	  � 	  τ 	  � 	  τ 	  � 	  τ 	  � 	  τ 	  � 	  τ 	  �  	F���DebugGuideListWindow�BaseClass�BaseWindow�Config�DataGuide�Find�DataGuideDebug�DataGuideStage�FindbyGroupId�指向UI�执行脚本�指向血条�文字式引导�头像式引导�横幅式引导�必须点中目标区域�点哪都能完成本步步骤�只能由behaviorFunction来完成�一次性引导�可重复触发�__init�__BindListener�__delete�__Show�__ShowComplete�InitUI�OnSelectToggle�OpenGuideStageList�Select�StageSelect�RefreshStageInfo�OnPlayGuideClick�__AfterExitAnim�  ���� ���  ��  � ������	�   R    
�   R    �   R    �  ��SetAsset�Prefabs/UI/FightDebug/DebugGuideList.prefab�curSelect�chapterNum        �curSelectGuideIndex�curSelectStageIndex�curSelectGuideId�curSelectGuideStage�DebugGuideList�DebugStageList�toggleObjMap��������� ��   � ���� � � �  �� � � �  ��PlayGuideBtn_btn�onClick�AddListener�ToFunc�OnPlayGuideClick�BindCloseBtn�CloseBtn_btn��������� ��  ���������� ���  �  � �   �   � � � �   � �� � � �  � � � 	�  �  ��SetNotifyBlurBack�SystemBlur1�StaticBlur2�chapterNum�UtilsUI�CheckPCPlatform�Config�DataGuideStagePc�Find�FindbyGroupId�      �������� ���  � �  ��InitUI��������� 
��  �  � �ʀ �� �  �O  ����  �����	�����
� ����� �� �� ��  6  �  ƀ ��chapterNum�PopUITmpObject�TabBtn�NavTabsContent�transform�object�SetActive�TabBtn_tog�onValueChanged�RemoveAllListeners�AddListener�isOn�UnSelectTabText_txt�text�GuideUtil�GuideChapterName�SelectedTabText_txt�toggleObjMap�   ���� ��   � �  � �   � �  � B   � ��  ��� � �  ��UtilsUI�SetActive�UnSelect�Selected�OnSelectToggle�       ������������ �  9 8  �F� � � DK �  � DL M 6   � D  	 	�   ��) �� 
�  �� �DB  8 ��  8  ���� � �
 �  	
 �	 � D �   �C� 8  ���� �
  � �  � 8 �� �� �	  
 �  �	�
�	��	���	  ��	���� 8  ��	  �	  ��	��� ��  			�! 
 D		 "	#�	  
	 D	�� �  � 	 D	�  �  � �* �  � $��%&Ɓ ��curSelect�curSelectGuideIndex        �pairs�DebugGuideList�PushUITmpObject�GuideItem�TableUtils�ClearTable�guide_list�PopUITmpObject�GuideContent_rect�mod�InformationCtrl�GetPlayerInfo�uid�PlayerPrefs�GetInt�string�format�%d%d%d�tonumber�已播放完毕�播放次数（%d/%d）�GuideId_txt�text�GuideFinishState_txt�Select�SetActive�TraceImg�TaskItemBtn_btn�onClick�RemoveAllListeners�AddListener�table�insert�GuideList_sRect�verticalNormalizedPosition       �      ����  �	   �  	 D 	    	   � 	 D G  ��OpenGuideStageList�curSelectGuideId�Select�   
  ������������ Ԏ	      B�  8  �F� � DK � � � DL M 6  � D�  DK� 	 �
 		�� ��  �	��� �
�	���	 ��	�
  D	�
  D	
�
DO  �	����
 ��� �	 �=� �  ��
 �6  6  L M� 6   �F� ��stageList�id�pairs�DebugStageList�PushUITmpObject�GuideItem�TableUtils�ClearTable�ipairs�curSelectGuideStage�stage�PopUITmpObject�StageContent_rect�GuideId_txt�text�string�format�步骤%d�GuideFinishState_txt�stageId %d�Select�SetActive�TraceImg�TaskItemBtn_btn�onClick�RemoveAllListeners�AddListener�table�insert�StageList_sRect�verticalNormalizedPosition       �     ����  �	   �  	 � D G  ��StageSelect�    ������������ �  9 8  �F�    � DK� ��� 8  �    DL M� 6  F� ��curSelectGuideIndex�ipairs�DebugGuideList�Select�SetActive�   �������� ��  � 8  �Ɓ �  �ˁ ���	�� 8  ��  �  �� ́ �  �� � �Ɓ ��curSelectStageIndex�ipairs�DebugStageList�Select�SetActive�RefreshStageInfo�   �������� 	 	  �� �� �� �� 	�	 �� 
�	 �� �	 ���  8 ��� 8  ��  �  �   D � � �< 8 ��
 B�  8  � � �� �� 	 �� ��group_id�type�notes�Remark_txt�text�WindowName_txt�window_name�PanelName_txt�panel_name�Type_txt�Style_txt�style�End_txt�end_condition�click_node��UtilsUI�SetActive�InfoNode�ClickNode_txt�is_lock_click�False�True�LockNode_txt�WidgetName_txt�widget_name�Server_txt�         �������� 
��    �   8
 ��  8	 �B  8 �@ 8 ��� �� ������   �    � �		�	
�� ��curSelectGuideId�curSelectGuideStage�PlayExitAnim�Fight�Instance�clientFight�guideManager�PlayGuideGroup�GuideUtil�GuideCallType�GM�   �������� ��   � ���  � �  ��WindowManager�Instance�CloseWindow�   ���������