LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π     �      π     �      π     �      π     � 	     π	     � 
     π
     �      π     �      π     �      π     �   F ��MaiLingBanYunBase�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�Init�Update�CreateActor�LookAtInstance�ResetLevel�Black�autoStart�FailTransfer�levelCamera�LevelCameraPosToPos�RemoveLevelCamera�guide�LevelStart�LevelSuccessCondition�SuccessCondition_Collection�LevelFailCondition�FailCondition_Distance1�FailCondition_Distance2�ChallengeLevelFSM�Assignment�LevelInstructionComplete�EnterArea�WorldInteractClick�OnBuildConnect�OnBuildDisconnect�StoryPassEvent�StoryEndEvent�  ���� �  G ��fight���������  �   R   H  �  ���������� �� ����  R   ����	��
�� �  R    R   ��� ���  �  R    R   ����  R   ����  R   ����  R   ����  �   R    ����� �!"�#$�%&�'(�)*�+,�-.�/0�12�34�56�78�9:�;<�=�>�?�  R    BCD� A BCF� E BCH� G BCJ� I @�KL�MN��O�PL�QL�RS�  R   ��U��V	��W��X��YZ��[\ T�  T� U ]�^_�`�a�b�c�d�e�f�g�h�i�  k� l�6 �  �  j�  j n� n�  ��missionState        �collectionCtrlState�inareaNum�ifCtrlState�collectionStateEnum�default�inarea       �outarea       �reset       �collectionList�entityIdm�     �bornPos�shoujiwu1�state�id �lookAtList�      �npc�tishi�player�levelCameraGroup�currentCamGroupNum�camera1�camera2�firstSwitch�startSwitch�firstInteractId���#    �cancelInteractId���#    �howInteractId���#    �leavelInteractId���#    �startInteractId���#    �friendInteractId���#    �inProgressInteractIdI��#    �interruptInteractId1J��#    �interruptInteractId2=��#    �restartInteractId��#    �outAreaInteractIdu��#    �disconnectInteractId1���#    �disconnectInteractId2��#    �successInteractId���#    �friendSwitch�guideSwitch�guidePointer�GuideTypeEnum�Police�FightEnum�GuideType�Rogue_Police�Challenge�Rogue_Challenge�Riddle�Rogue_Riddle�Jiujishou�Map_Jiujishou�levelInstruction�n�    �teachHN      �flag�logic�positionLevel�resetDistance�       �levelStateEnum�Default�Start�Ongoing�LevelSuccess�LevelFail       �LevelEnd       �levelState�levelName�将脉灵运送至目的地�isSuccess�lock�distanceLimit1�distanceLimit2�distanceLimit3�distanceWarningCurrentTime�distanceWarningEndTime�warningSecond�cancelTask�npcDisconnect�LevelCommon�BehaviorFunctions�CreateBehavior�LevelCommonFunction�levelId�   �������� 	��   ��� �  � �  �� � �  �  �$ ��� � � �  � 	 
�  � �� � �  �  
�� � �  �  
�� � �  �  
�  � �  �  
�	 �� �  �  
�  � ��  � � � � � �  �  �� � � �  �  
� ��
� � �� � ��  � � 8
 ��  � � 
�   � ��  �  
� � �  �  
�  � ��  � �  � � 8- ��  � ! "�  � �  � 	 
�  � �  �  
�  � �� #� �  �  
�  � �  �  
�  � �  �  
� � �  � &� � "�  %�  � ( %� � )� �  � + �   -�   "� "�  *�  � / 
� 0�1���  �  .�  � / 
� 3�4�5���  ��  2�6�  � � 8 ��  � 7 8� � 9 � ��  � : 8� �;�  � � 8 ��  < =>�  �	 ��� ?��� ����� � @��D� A� B  �   D� C �D�� D� ��  ��LevelCommon�Update�role�BehaviorFunctions�GetCtrlEntity�ChallengeLevelFSM�missionState�CreateActor�collectionList�SetThingCanJoint�id�LookAtInstance�PlayAnimation�ExceptionLoop�ChangeNpcHeadIcon�Textures/Icon/Single/FuncIcon/Map_jiujishou.png�ShowCharacterHeadTips�ChangeNpcBubbleContent�好想去到那里...�SetNonNpcBubbleVisible�firstSwitch�SetVCCameraBlend�**ANY CAMERA**�LevelCamera333333�?�resetDistance�GetDistanceFromTargetWithY�lookAtList       �SetRigidbodyEntityLookAtTarget�SetPartFreezeRotation�autoStart�SetLevelUnloadUnbindStatus�levelId�LevelStart�Stand�levelTips�AddTips�n�    �ChangeSubTips�inareaNum�tishi�CreateEntityByPositionq%     �bornPos�guidePointer�AddEntityGuidePointer�GuideTypeEnum�Jiujishou�guideMailing�FightEnum�GuideType�Map_Jiujishou       �CheckTeachIsFinish�teach�ShowGuideImageTips       �levelState�levelStateEnum�Ongoing�FailCondition_Distance1�FailCondition_Distance2�cancelTask�LevelFailCondition�SuccessCondition_Collection�LevelSuccessCondition�   �������� ��   8 �  � DK  �DL M 6    � DK  �  �  �  D�L M 6  F� ��ipairs�BehaviorFunctions�RemoveEntity�id�CreateEntityByPosition�entityId�bornPos�levelId�   �������� ��    � � 	 � � � � �  �	
� � D
�  � 
 �   �  � 胈   �   � �  ƀ ��ipairs�lookAtList�BehaviorFunctions�GetTerrainPositionP�bornPos�levelId�id�CreateEntity�entityId�x�y�z�LevCameraPos�CreateEntityByPosition�npcCamera�   �������� 	��   �   8 ��    � �  � ���  �  �   ƀ ��collectionList�ipairs�BehaviorFunctions�RemoveEntity�id�   �������� ��   �   � � �� �    � � �� �   �  �  � � �  ��BehaviorFunctions�ShowBlackCurtain333333�?�AddDelayCallByTime�������?�ResetLevel      �?�   �������� �� �  �   � ��   � ˀ � ���  8  �� �  ̀ �   �  �  8	 ��   �  � ��  	� � 8 ��� 
� �� � �  �  � ��  �   8 ��   � �  � � ���  8 ��� 8 ��  D � �	�	�	 D � �	�	�
 D � �	�	  D � �	�	 ��D � �	�	  D�  �  �   ƀ ��collectionCtrlState�collectionList�ipairs�BehaviorFunctions�CheckEntityOnBuildControl�id�ifCtrlState�missionState�FailTransfer�lookAtList�bornPos�StartStoryDialog�firstInteractId�lock�GetDistanceFromTargetWithY�CreateActor�PlayAnimation�ExceptionLoop�ChangeNpcHeadIcon�Textures/Icon/Single/FuncIcon/Map_jiujishou.png�ShowCharacterHeadTips�ChangeNpcBubbleContent�好想去到那里...�SetNonNpcBubbleVisible�   �������� ��  �  � �  �  D�  �  � ��� �   �  �	�	
��� ��   �  �	 �  �
�	�� �   �  �	  � ��� ��BehaviorFunctions�GetTerrainPositionP�levelId�ShowBlackCurtain�������?�AddDelayCallByTime      �?�InMapTransport�x�y�z333333�?�DoLookAtPositionImmediately�roleffffff�?�   �������� � R   � �� �	��� 	� �	 �   �B  � �� �		 ��   ��  � �� �		� �   ��  �	
 
�  �	 D
� 
� �	 � �� �	 � 

 �   �� �	 � 

 �   �A � ��� �    �  �� � � ��camEntity �lookatEntity�rolesBindTransform�currentCamGroupNum�table�insert�levelCameraGroup�BehaviorFunctions�SetVCCameraBlend�**ANY CAMERA**�LevelCamera�CreateEntity�levelId�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   �������� � R   �� ���� �/�  �  � D�  � � 	� � � DB  � � 	��  � D �  D� �	  � � � 
� �胈  �� 
 �
 � 
� �胈  	�		� 
 �
 � 
� �  � 
 �
  
�  ��  � D 
�  ��  � DA � ��   �   � D H G ��camEntity �followEntity�lookatEntity�currentCamGroupNum�table�insert�levelCameraGroup�BehaviorFunctions�SetVCCameraBlend�**ANY CAMERA**�LevelCamera�GetTerrainPositionP�levelId�CreateEntity�x�y�z�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�RemoveLevelCamera�   �������� 
�  � DK 9 � �B  � � �DB  � � �DB  � � �DB  � � �DL M 6   � � � D ��  � DF� ��ipairs�levelCameraGroup�camEntity�BehaviorFunctions�CheckEntity�RemoveEntity�lookatEntity�SetVCCameraBlend�**ANY CAMERA**�LevelCamera333333�?�   �������� 	��   �  �   � �� D�  �  � ��� 8 � B  � � 	<
 8 �  � D�	�� 8 ��� 8 � 	< � �  � �� ���  D �	
�� 8 � B  � � 	<
 8 �  � D�	G ��BehaviorFunctions�GetPositionP�role�GetTerrainPositionP�lookAtList�bornPos�levelId�GetDistanceFromPos�guidePointer1�guideSwitch�RemoveEntityGuidePointer�AddEntityGuidePointer�collectionList�id�GuideTypeEnum�Jiujishou�   �������� ��    �  8 ��  �   �  ��levelState�levelStateEnum�Default�Start�����������   �   R   P  �   4 ���  � DK � �  �����L M 6  � �	 � � �9 8 � �� D � 	D 
� D  F���ipairs�levelState�levelStateEnum�Ongoing�BehaviorFunctions�RemoveTips�n�    �RemoveEntity�tishi�RemoveEntityGuidePointer�guideMailing�LevelSuccess�   �������� ��  B  � � � DK� � �	9	 � � = 8 � �/�  	
�  �� D�� �	9	 � � =� 8 � ~/�  	
�  �� D� 	�DB  8  �� L M� 6   B  8 � � DK  	� �	�	DB  8	 �?� 8 �� �	�	@� � �� ;	 8 �� �	�	� � 8 �� �	�	L M 6   9 � �  < 8 � 	� D  F� �  �  F� F� ��collectionCtrlState�collectionList�ipairs�state�collectionStateEnum�inarea�flag�inareaNum�BehaviorFunctions�ChangeSubTips�levelTips       �outarea        �CheckEntityOnBuildControl�id�GetDistanceFromTargetWithY�lookAtList�resetDistance�reset�StartStoryDialog�successInteractId�   ��������
��   �   R   P  �     � DK	 � � � � �	9	 8 � � D � 	D 
 L M
 6  F���ipairs�levelState�levelStateEnum�Ongoing�BehaviorFunctions�RemoveTips�levelTips�RemoveEntity�tishi�LevelFail�   �������� 
�  �  D�  �! �� � 8 ��  �� � 
�
�� 	 �8 ��  �� � 	 : � �� � 	� #.
0
� � 8 �  B�  � �  ��  � D 8 �  �   D8 ��  � ���  �� � �� � 8 �� � � ���  � ��: � ��  �� � �� � �  � � ��BehaviorFunctions�GetDistanceFromTargetWithY�role�collectionList�id�distanceLimit1�distanceWarningCurrentTime�GetFightFrame�distanceWarningEndTime       �warningSecond�math�ceil�levelFailTips�AddTips��    �levelId�ChangeTitleTips�RemoveTips �ShowLevelNotice[��    �脉灵运送�levelState�levelStateEnum�LevelEnd�   �������� 
�� � � DK� � �	9	 � �  �/�  L M� 6    @ 8 � 	< 8 � D 
 
�� ".  �	� � D 
 � 
� � � �  
����D� : � � �   � �� ��
 �   � �
 �� � � �� � � D  F� 8 � 	< � ��	 � D�  F� F� ��resetNPCNum        �collectionCtrlState�ipairs�collectionList�state�collectionStateEnum�reset�distanceLimit2�distanceWarningCurrentTime�BehaviorFunctions�GetFightFrame�distanceWarningEndTime       �warningSecond�math�ceil�levelDistanceTips�AddTips�n�    �levelId�ChangeTitleTips�StartStoryDialog�outAreaInteractId�RemoveTips �   �������� ��    �  8  �� ��    �  � ��  �  ��  � �  � 	  8 ��    	�  8  �8 ��    
�  �  ��� ��    �  �  ��8 ��    �  � ��  �  8 ��  �  � � ��  �  � �  ��levelState�levelStateEnum�Default�Start�BehaviorFunctions�ShowLevelNoticeY��    �脉灵运送�将脉灵运送至目标地点�Ongoing�LevelSuccess�isSuccess�LevelFail�LevelEnd�FinishLevel�levelId�RemoveLevel�   �������� � � ���������� �G ���������� ��   �ˁ	 �� 	 � �< � �� �� 8 �� �	� �   	�   
� 
�� ́
 �  Ɓ ��ipairs�collectionList�id�InArea�missionState�BehaviorFunctions�CreateEntityByPositionr%     �lookAtList�bornPos�levelId�   �������� ��  ��� 8  ��� � � ��  ��� 8 �� � � �� � ��  ��� 8 �� � � �� � 	�� ��collectionList�id�lock�firstSwitch�BehaviorFunctions�StartStoryDialog�firstInteractId�startSwitch�inProgressInteractId�   �������� ��  ���� 8 ��  ��9 8 �� �  �  �� ��collectionList�id�BehaviorFunctions�SetEntityInteractActive�   �������� 	�  �� 8 �  9 8 � �  ��  DG ��collectionList�id�BehaviorFunctions�SetEntityInteractActive�   �������� 
�  < �" � �  8 � � �� D �  D� � 	�  8 �� 
 D� 
 D� � �  8 �� 
 D� 
 D� � �  � ������8 � �  � �� ����� ��  � D � � �  8 �� D� � �  8  ��G ��lock�firstInteractId�BehaviorFunctions�SetRigidbodyEntityLookAtTarget�collectionList�id�role�DoLookAtTargetImmediately�cancelInteractId�RemoveLevelCamera�camera1�camera2�leavelInteractId�startInteractId�firstSwitch�startSwitch�ifCtrlState�friendSwitch�missionState       �friendInteractId�LevelCameraPosToPos�camPos�tishi      �?�outAreaInteractId�Black�interruptInteractId2�cancelTask�   �������� 	�  < 88 � �  8 � ��  D�  �   	� �D80 � �  8 ��  D�  D < 8* ��8) � �  8  �8' � �  8 � ��  D�  �   	� �D8 � �  8 �� D �  D� � �   	� �D8 � �  � � � �� D �   D�  �   D�  �    � D�  �   !� "��# "#D�  ��  �   �DG ��lock�outAreaInteractId�BehaviorFunctions�ShowLevelNotice[��    �脉灵运送�AddDelayCallByTime      �?�Assignment�levelState�howInteractId�RemoveLevelCamera�camera1�camera2�friendSwitch�missionState       �disconnectInteractId2�interruptInteractId2�successInteractId�BlackZ��    333333�?�restartInteractId�PlayAnimation�collectionList�id�ExceptionLoop�ShowBlackCurtain�������?�ResetLevel�CreateActor�FailTransfer�lookAtList�bornPos�   ���������