LuaT �

xV           (w@��� �Q     �    D        �  �  � �  �  	  ς  
  �  �  O� ��  O ��  O� ��  O ��  O� ��  O ��  O� ��  O ��  O� ��  O ��  O� ��  O �� O� �� O �� O� �� O	 �� O�	 � � !�"� �
 # σ
 $ � % σ &F���ClientWeaponComponent�SimpleBaseClass�PoolBaseClass�math�min�max�table�insert�remove�__init�Update�Init�Config�DataHeroMain�Find�BindWeapon�GetWeaponPosition�GetWeaponByBindName�GetWeaponTransByBindName�ChangeWeapon�PlayWeaponAnimation�AddWeaponEffect�RemoveWeaponEffect�RemoveAllWeaponEffect�AfterUpdate�SetTimeScale�OnCache�ClientWeaponComponent�__cache�__delete�PTMMove�RevertWeaponInfo�UpdatePos�Vec3�New�UpdatePosition�FlyWeapon�WeaponMoveEnd�TestUpdate�  ���� ��   R     �   R    �  ��weaponMap�weaponAnimators��������� ���  � �� � �� � �  ��UpdatePos�TestUpdate�AfterUpdate��������� �   � D  R    �G ��clientFight�clientEntity�BindWeapon�effects�effectInstance        ��������� ��   � � �   8 �B�  8 �  � ���� �  � �  ��  �: � ��  �J�3 	 	B  8. ��  �	
��	� ��  8 �	@ � � � DB  8 ��		~/�D� �
��	 �  �  �B  8 �� �
��	 �
 �� ���� ��
� 
�
D��	 
� �  �
���
  �
��
����  R   ���
�
 �  R   !�
��#� $�"�
�&%�� '
�( )D�� �� *� � �I4  ,-�  �
�D  
�.DG ��clientEntity�entity�root�masterId�mod�RoleCtrl�GetRealRoleId�RoleConfig�GetWeaponAsset�bind�clientTransformComponent�GetTransform�childCount�next�weaponMap�GetChild�string�find�name�ClientWeapon_�gsub��clientFight�assetsPool�Cache�path�gameObject�Get�SetTransformChild�transform�ResetAttr�obj�weaponTrans�cacheGroupTransform�transformGroup�GetComponent�BindTransform�parentTrans�parent�weaponAnimators�GetComponentInChildren�Animator�LogError�角色的战斗武器需要的挂点数量和角色拥有的挂点数量不匹配,请联系<系统策划>修复hero表.  角色id = �CustomUnityUtils�SetShadowRenderers�ReSetMeshRendererGetter�    �������� ��    DB�  8  �� �� � ��GetWeaponTransByBindName�position��������� �  B  � �  H G ��weaponMap�obj��������� ��  ��  � �B  � �<� � �9 �  �H B  8 �H B�  8  �G ���� �H G ��weaponMap��weaponTrans�name�cacheGroupTransform�transformGroup�GetTransform��������� �G ���������� �  B  � �� ������ 8 ���B�  �  �'�� R   ��� � ��weaponAnimators�clientEntity�entity�timeComponent�GetTimeScale�waitPlayParam�index�name�fixedTimeOffset��������� ��  �  8 ��   �  8  �Ɓ � ���� �  8  �F�  �/�� ���� �   R   ��   �˂ �
��	� 
�  8  ��	 ��D� ��	 � � R   D� ͂ �  F� Ƃ ��weaponMap�next�clientFight�assetsPool�Get�effectInstance�effects�pairs�obj�GetComponentInChildren�SkinnedMeshRenderer�transform�SetParent�gameObject�localPosition�Vector3�path�    �������� �  B�  8  �F�  �  �DK  ��DL M 6    �F� ��effects�pairs�clientFight�assetsPool�Cache�path�obj �   �������� 
��    � ˀ �� � ��  ̀ �   ƀ ��pairs�effects�RemoveWeaponEffect�   �������� ��     8  ��  �    �B  �
 �� ������ 8 ���B�  8 �'.���	����� 

$
.
�� � ��waitPlayParam�weaponAnimators�index�clientEntity�entity�timeComponent�GetTimeScale�fixedTimeOffset�CrossFadeInFixedTime�name�FightUtil�deltaTimeSecond �   �������� 
�  � DK�  � DB�  8  ��L M� 6  F� ��ipairs�weaponAnimators�UtilsBase�IsNull�speed�   �������� ���  � �   � �  � ������  �  �   �  � 	 � �  � 
� ���    � ƀ ��RemoveAllWeaponEffect�pairs�weaponMap�clientFight�assetsPool�Cache�path�obj�TableUtils�ClearTable�fight�objectPool�ClientWeaponComponent�   �������� ��  ���������� �� ��  ��clientFight �clientEntity���������	 ܎  �		�

 �  8 �� ���� � 8  ��	 �  8 �� �  8  ��  
�    �  ������ ��D� �� ����  	� 	 �� �B  8 �B�  8 ��  8 � �� D8 ��  !"#D $%�&�'�(D� )  D� � �  ƈ ��clientEntity�entity�skillComponent�target�targetPosition�skillTargetPos�clientTransformComponent�GetTransform�targetTrans �allFrame�isPTM�isRevert�boneName�maxSpeed�minSpeed�transformComponent�rotation�ToEulerAngles�Vector3�Quaternion�AngleAxis�y�up�targetOffset�PTMIgnoreY�pairs�weaponMap�obj�SetTransformChild�transform�SetParent�clientFight�clientEntityManager�entityRoot�UnityUtils�SetRotation�x�z�w�UpdatePosition�   �������� 
�� �   � �  � �  8 �����������	��  �  �   ƀ ��isPTM�pairs�weaponMap�isRevert�obj�transform�SetParent�parentTrans�ResetAttr�   �������� 
��     8  �ƀ �  �  8 ��� � ƀ �   � ˀ �� ���  ̀ �   ƀ ��isPTM�allFrame�RevertWeaponInfo�pairs�weaponMap�UpdatePosition�obj�   �������� � � ����� � � �  �  �� 	�
 
��� 
� ��� � ��� �	 B  �  �� 	 #.� �  �  � �
�
#	.	0
��	
�
�	�
"	.	��	
�
�	�
"	.	� '��   � � 	 �   � � 	 �.�	� 
� 
�	
".�	���	".D 
~/� 
G ��transform�clientEntity�entity�timeComponent�GetTimeScale�skillTargetPos�UtilsBase�IsNull�targetTrans�position�x�targetOffset�y�z�PTMIgnoreY�Vec3�Normalize�math�sqrt       �allFrame�maxSpeed�minSpeed�UnityUtils�SetPosition�       �������� �  ���� DB�  8  �Ƃ � �  �  ��Ƃ �	�
 � DK�	 ���� ����� ���	�����L M�
 6  �  �  DB  8 ���� ����� � � � ���ƃ ��clientEntity�entity�clientTransformComponent�gameObject�transform�GetComponent�BezierTrack�isFly �transformComponent�rotation�pairs�weaponMap�obj�SetParent�clientFight�clientEntityManager�entityRoot�UnityUtils�SetRotation�x�y�z�w�SetMoveTrans�GetTransform�SetBindTransform�SetBezierMoveEndCb�ToFunc�WeaponMoveEnd�StartMove�   �������� �� �� � ��  ��isFly �RevertWeaponInfo�isRevert��������� ��     8  �ƀ �   � �  ����	� �������� � �  �  �   ƀ ��isFly�pairs�weaponMap�obj�transform�rotation�eulerAngles�Rotate�Vector3�   ���������