LuaT �

xV           (w@��� �Q     �    D    ���   O  � �   O�  � �   O � �   O� � �   O � �   O� � �   O � 	�   O� � 
�   O � �   O� � �   O � �   O� � �   O � �   O� � �   O � �   O� � �   O � �   O� � �  R    �  �  �   �	   ρ	    �
 !  ρ
 "  � #  ρ $ %&� %�' %(� %�)  � *  σ +  � ,  σ -  � .  σ /  � 0  σ 1  � 2  σ 3F���DebugDamagePanel�BaseClass�BasePanel�__init�__BindListener�__BindEvent�__CacheObject�ShowDisplay�__Show�OnClick_Start�MoveButton�StartRecord�StopRecord�OpenReport�CloseReport�RealStart�UpdateTime�OnDoDamage�BuffChanged�RecrdBuff�SetCurEntity�Limit�FightEnum�PlayerAttr�Curqteres�ExSkill�EntityAttrsConfig�AttrType�ExSkillPoint�Skill�NormalSkillPoint�PlayerAttrChange�EntityAttrChangeImmediately�SaveData�ShowContent�ShowTeamPart�CheckInFront�DmageDebugConfig�SkillTypeP�M_SkillType�SkillType2M�M_SkillTypeName�ShowRolePart�GetDamageType�ShowBuffPart�ShowTimelineV1�ShowTimelineV2�GetBuffDataByIndex�OnClick_Team�OnClick_Curve�OnClick_Role�OnClick_Buff�  ���� ���  ��  � ��   R    �   R    �  ��SetAsset�Prefabs/UI/FightDebug/DebugDamage.prefab�recording�records�recordObjs��������� ��   � ���� � � �  �  � ���� � � �  �  � ���� � � �  �  	� � D� 
�  � ���� �� � �  �  � ���� �� � �  �  � ���� �� � �  �  � ���� ��	 � �  �  ��StartBtn_btn�onClick�AddListener�ToFunc�OnClick_Start�ReportBtn_btn�OpenReport�Close_btn�CloseReport�Move_drag�onDrag�MoveButton�Team_btn�OnClick_Team�Curve_btn�OnClick_Curve�Role_btn�OnClick_Role�Buff_btn�OnClick_Buff��������� ��   � ��� ��  D �  �   � ��� ��  D �  �   � ��� �� � D �  �   � ��� ��  D �  �   � ��� �	�  D �  �  ��EventMgr�Instance�AddListener�EventName�EntityAttrChangeImmediately�ToFunc�PlayerAttrChange�SetCurEntity�OnDoDamage�OnEntityBuffChange�BuffChanged�   �������� ���  � ��� �  ��SetCacheMode�UIDefine�CacheMode�hide�   �������� ��  ���������� ��  ���������� ��   �    �   �   8 ��� � �  ��� � �  ��recording�StartRecord�StopRecord��������� �  � �  �����".�� ��ButtonGorup_rect�anchoredPosition�UnityUtils�SetAnchoredPosition�x�delta�y�   �������� ��   ���  � �  ���  ���  R   ��	��
��	  R   �   R   �   R   �   R   �  �  ��CurTime�SetActive�CurTime_txt�text        �StartDesc_txt�停止统计�curRecrd�startFrame �lastFrame�curEntity�entityDamage�entityBuff�entityState�costRecrd��������� �   ���  � �  ���  B�  8  �F� �#.��  � ��	�4 
� 	�� �   �˄ �: �  ��� ��
: 8  �
� ̈́ �  � �	 �  � �ˁ �   �� �: 8  ��� � �  � ́ �  � �� ��� � DK  � DK : 8 ��	�L M 6  	L M 6  � � �  �� �Ɓ ��CurTime�SetActive�StartDesc_txt�text�开始统计�curRecrd�startFrame�lastFrame�curEntity�entityState�endFrame�pairs �entityBuff�frame�costRecrd�value�SaveData�   �������� ��   � � �  ���  � �   � �   8 � B�  � ��  DG ��BehaviorFunctions�Pause�Window�SetActive�next�records�curObj�ShowContent�   �������� ��   � � �  ���  � �  ��BehaviorFunctions�Resume�Window�SetActive�   �������� ��    �D�D�� ��  R   �� R   ��	
 ��  D �D�D�   �˂ �� �
 �� ͂ �  Ƃ ��curRecrd�Fight�Instance�playerManager�GetPlayer�GetCtrlEntityObject�curEntity�entityId�entityState�startFrame        �table�insert�GetEntityList�pairs�RecrdBuff�   �������� ��   �   � � 	  '� � ��   D�� ��curRecrd�lastFrame�startFrame�CurTime_txt�text�string�format�%0.2f�     ��������
 �  B�  8  �G  
� D�
�  8 ��
���  8  �� �  �D�	  8 ��	�� 
���� 8  ���� ��	�. � ��D�
��  �  ��  R   �  R   �����C�	 8  ����	 	�	  
 D	G	 ��recording�BehaviorFunctions�GetEntity�tagComponent�IsPlayer�curRecrd�Fight�Instance�GetFrame�startFrame�RealStart�lastFrame�UpdateTime�GetDamageParam�FightEnum�DamageInfo�SkillType�entityId�entityDamage�frame�magicId�skillType�damage�elementBreakValue�table�insert�   �������� 	�  B�  8  �G  �  8  �� � �  ��  � �B  8 ��DB�  8  �G �   DG ��recording�curRecrd�startFrame�BehaviorFunctions�GetEntity�tagComponent�IsPlayer�RecrdBuff�   �������� � ���� � DK�  
�   DB�  � � 
�   DB�  8  ���L M� 6   	�
D� ��. �  �  ��  R   � R     R   �� � DK �  � ��  D� R   ��@ �  �L M 6   �DB�  8  �F�  �DB  � ���	 	��
 � ��4
 ��
 �  DF� ��entityId�buffComponent�GetTotalBuffId�pairs�BehaviorFunctions�CheckIsBuffByID�CheckIsDebuffByID�Fight�Instance�GetFrame�curRecrd�startFrame�entityBuff�infos�frame�GetBuffCount�count�buffId�next �table�insert�   �������� 	��     8  ��  �  B�  8  �G  �D��. �D�D	�
9 8  �� �
�  � ��
�4 � 
�
�
�  �  ��  R   �� R   � �
�  DG ��recording�curRecrd�startFrame�Fight�Instance�GetFrame�playerManager�GetPlayer�GetCtrlEntityObject�entityId�curEntity�entityState�endFrame�table�insert�   �������� �  B�  8  �G  �  8  �� � �� 8  �� � 8  �� �����#���B  � ���
B�  �  �  R   	
�	�  
B�  �  �  R   	
�	�	
 
� R   ���G ��recording�curRecrd�startFrame�Limit�Fight�Instance�GetFrame�curEntity�costRecrd�table�insert�value�frame�    �������� ��    8  �� � B�  8  �G ; 8  �G  9� � � 9� 8  �G B  8 ��DB�  8  �G �	D��.
�.��  �  ��  R   
�
  �  ��  R   ��
� R   �	��� ��recording�curRecrd�startFrame�Skill�ExSkill�tagComponent�IsPlayer�Fight�Instance�GetFrame�entityId�costRecrd�table�insert�value�frame�    �������� ��   �  �  � D�  ��� 	 � D����  �����  ����� �����������  �Ɓ ��TableUtils�CopyTable�curRecrd�name�os�date�%H:%M:%S�records �PopUITmpObject�TitleObj�LeftContent_rect�Select�SetActive�UnSelect�Name_txt�text�recordObjs�_btn�onClick�RemoveAllListeners�AddListener�   ����  �	   �  	 D G  ��ShowContent�   ������������ �  B  8 �  �9 ���  B  � �  �  D  �  D �    �  D  �  D� � � D� � � D�  � D� � � D�  � D� � � D�  � D� � � D�  � D� � � D�   D�   D�   DG ��curObj�name�Select�SetActive�UnSelect�recordObjs�PushAllUITmpObject�TeamObj�Cache_rect�CurveBar�DamageObj�DamageGorupObj�SkillObj�SkillGorupObj�BuffObj�BuffGorupObj�TimelineObj�TimelineGorupObj�ShowTeamPart�ShowRolePart�ShowBuffPart��������� � R   � �����  R   �  R   �  R   �  R   	�� �� 
��1 �  R   �� R   �� �   
� DK�) 
 
�
�
~�
�	 �
�
D

�/
�: �  �C� ����
B�  � � R   ��  R   �
�
�
�".�
�
 �
� �
�
  � ��
 R   ��  R   �
��
�".�
�
 �
� �
�
 �".�
 �
 �
�
 �
�
�
L M�* 6  � �2 �  � �  � �ʃ � 
  �� �
  � �� R   ��	  R   �
� � �  �
  � �� R   ��  R   ��
� � 
�� � 
  �ˆ �	  �  ��	  R   �	

B�  8  ����	�	

�
�
�
"
.
�	� ͆ �  � � �  � 
	 �� �	��� � �  � 
�˃ � 
  �� �		
	
"
.
�	� � �  � ̓ �  � �	 �� '.�	� �  �
  �   �			�	�		
 
	D	�� 
��3 �� !�	 
 #�	B�  8  ���	�	 '	.	�	   8  ���� �	 �	�	

B
  � �

�

B�  8  ����
$��%�
&�
�
' �  D�
�
) �  � '.+0+D� 5 �
�
- �   ����+�+D� 5 �
�
/ �  '.D�
�
0 � C� 8  ���D�
�12�
3�
4��5�
�
3�
4��6�  �
�  �  � �4 �  �  R    7�89� :  �˅ �;	 8:	 8 ��;  8  �� 8 8� ͅ �  � :  ��	 � R   �<� !� �
 >D	�	?
;�
 8'
.
�	@�	A��@B�C�	 7�	� �
 �  ƅ ��totalDamge        �totalBreakValue�totalFrame�lastFrame�startFrame�entityAreaDamage�teamAreaDamage�entityDamageInfo�totalCost�pairs�entityDamage�math�floor�frame�total�infos�damage�table�insert�elementBreakValue�entityState�endFrame�costRecrd�teamReslut�累计伤害:%.0f 战斗时间:%.0f秒 DPS:%.0f 累计五行击破:%.0f 日相消耗:%.0f 月相消耗:%.0f 绝技点消耗:%.0f�TeamResult_txt�text�string�format�Skill�ExSkill�Limit�PopUITmpObject�TeamObj�TeamContent_rect�BG_canvas�alpha�Text1_txt�Text2_txt�%.0f�Text3_txt�%0.2fd       �%�Text4_txt�%.0f&%0.2f�Text5_txt�Text6_txt�selectRoleObj �_btn�onClick�RemoveAllListeners�AddListener�DamageBar�maxAreaValue
       �ipairs�total�index�CurveBar�CurveContent_rect�_img�fillAmount�ChildBar_img        �obj�      ����  �   B   8	 �     �   �  9  � � �  D K� �L  M� 6   � 	F� 	      �
 	 �  � D K   ��� '	.	��  @ � �	  �� 
� D� �  � ��
8 ��L  M  6   F� ��selectRoleObj�BG_canvas�alpha        �pairs�DamageBar�obj�ChildBar_img�fillAmount        �ipairs�total�maxAreaValue�CheckInFront�entityState�ChildBar_canvas      �?�         ������������ ��  �.�~��	  #��/��   �� �
: 8 ��
� �  ��  ƅ �
� 8 ��
� �  ��  ƅ � �	 �  �  Ƃ Ƃ ��ipairs�endFrame�startFrame�     �������� � R   �  R    �  R   � � �˂" �  R   �	�  
 �˅ �� �	�		B�  �  �	  R   �			�		�	  8  ����			�		�	
�	�			�		  �  ��	  R   	�		
	
B�  � �
 R   �	�
	
�	�	�		�	
	


�/
��	�		�	
	

�
"
.
�	� ͅ �  � ͂# �  � �   �� �� ��  ���	  	 � 	� 	 �� �		�	  8  ����� � �D
�
	 �
�
 ��   D�
�
 �� '�	 0 D�� 5 �
� � �  � � �  �   �� �� �  #���	  	 � 	�  
 �� �� �
 �	


�


�
 �


%�&� �	 �  � � �  Ƃ ��roleDamages�roleSkills�pairs�entityDamage�GetDamageType�skillType�damage�magicId�count        �atkCount�type�total�roleResult�PopUITmpObject�DamageGorupObj�DamageContent_rect�EntityId_txt�text�角色ID:�teamReslut�entityDamageInfo�totalDamge�DamageObj�Content_rect�Text1_txt�Text2_txt�string�format�%.0f�Text3_txt�%0.2fd       �%�SkillGorupObj�SkillContent_rect�SkillObj�Text4_txt�/�     �������� �  � DK�  � DK  �   DB  8 �	 F� L M 6  L M�	 6  F� F� ��ipairs�pairs�BehaviorFunctions�AnalyseSkillType�Other�      �������� � ��  R    R   �  R   �  R   �  R   �   �˃; �  R   ��  R   ��  R    � DK& 
 �
D
K
 	B�  � �	� R   �
	�	�L
 M
 6
  
 �
 D
K
 B�  � ���
#.��B�  8  ������".���B�  �  �  R   �� �� R   
�
����L
 M
 6
  L M' 6   �	 ��D�  R   �� �  � �� �� �
   �	�	  � �

�

ɇ � ̓< �  �   �� �� ��
  ���   �  ��DB  8 � ��DK� � � �D
�
�
�
  �� 	 '�	D�
L M� 6  � � �  �   �˃ �� �  #���   � � $  �  	 �	 D� ̓ �  ƃ ��entityBuff�entityDamage�teamReslut�buffLine�timeline�times�pairs�ipairs�infos�buffId�startFrame�frame�endFrame�table�insert �math�floor�totalFrame�GetBuffDataByIndex�PopUITmpObject�BuffGorupObj�BuffContent_rect�EntityId_txt�text�角色ID:�next�BuffObj�Content_rect�Text1_txt�Text2_txt�string�format�%0.2f�TimelineGorupObj�TimelineContent_rect�ShowTimelineV1�     �������� ��  �� '.� ��  �J� �  �D�
�	�
��	� 
��  8 �� 
	��  �	 ���  ���	DK 	 	��  
 �
D	� L M 6  
I F� ��math�floor�totalFrame�PopUITmpObject�TimelineObj�Content_rect�Text1_txt�text�Text2_txt��next�timeline�pairs�string�format�%s  %s&%s�buffId�count�     �������� � �� �~�� �J �  �  �D��	 �  	 �� � �	 �	
 
	�

�  � � �  � �� � '.������	 ��D���
I� F� ��PopUITmpObject�TimelineObj�Content_rect�infos��pairs�string�format�%s  %s&%s�buffId�count�Text1_txt�text�%0.2f ~ %0.2f�frame�Text2_txt�     �������� ��  �.�~�� � DK� 	�
 � �~/��
ƅ L M� 6  4 F� F� ��ipairs�frame�     �������� ��   �  8 ��     8  ��     �   �    �  ���  � �  ���  � �  ��showTeam �TeamBG�SetActive�TeamGorup��������� ��   �  8 ��     8  ��     �   �    �  ���  � �  ���  � �  ��showCurve �CurveBG�SetActive�CurveGorup��������� ��   �  8 ��     8  ��     �   �    �  ���  � �  ���  � �  ��showRole �RoleBG�SetActive�RoleGorup��������� ��   �  8 ��     8  ��     �   �    �  ���  � �  ���  � �  ��showBuff �BuffBG�SetActive�BuffGorup����������