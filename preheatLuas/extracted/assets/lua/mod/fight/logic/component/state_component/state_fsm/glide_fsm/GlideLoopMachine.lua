LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	���    ρ   �   ρ   �   ρ   �   ρ   �   ρ   � F���GlideLoopMachine�SimpleBaseClass�MachineBase�Init�OnEnter�OnEnterByInherit�GetInheritData�CanJump�NormalizeEuler�GetGlideLoopStateAnimation      �?�Update�CheckReverGlideState�CanMove�CanCastSkill�CanLand�CanDoubleJump�CanProactiveDown�CanHenshin�OnLeave�OnCache�  ���� �      R     � � � �	
 �G ��fight�entity�glideFSM�params�rotateOffsetZ        �rotateOffsetX�maxAngle
       �angleSpeed      �?�lastAngle��������� Î   �   � ��  � ���   �  D�   � ��� � � 	
D     R   � ���� ���� ��� ��� � ���   �� ���� ��!��"  �#  DG ��glideFSM�gliderGo�entity�clientTransformComponent�BindGlider�BindGliderGo�GetComponentInChildren�Animator�Play�Config�EntityCommonConfig�AnimatorNames�GlideLoop�moveComponent�yMoveComponent�speedY�attrComponent�GetValue�EntityAttrsConfig�AttrType�GlideSpeed�gravity���������accelerationY        �maxFallSpeed�config�GlideDownSpeed�SetConfig�transformComponent�GetRotation�params�lastAngle�ToEulerAngles�y�SetNotUpWithoutStableOnHit�   �������� 	��  �DK  L M 6  F� ��inheritFrame�pairs�params�   �������� ��   �  �  �   �  ��TableUtils�CopyTable�params�   �������� ��   �  �  ���������� ����  8 ��  �  8 ��Y�: �  ��  �  �  G �h      ��������� ��     8  ��  �  � � �   � ��9 8 � � 8
 �  � ��	9 8 � � 	� �  � ��
9 � � � 
  � F G ��animState�Config�EntityCommonConfig�AnimatorNames�GlideLoop�FightEnum�GlideLoopState�Front�GlideLoopFront�GlideLoopRight�GlideLoopLeft�   �������� ��   �   �  �� �  �  � � ��� �   8F � ����	D� 
�����D	����	#.�� � �  �   � ���   8  ���� � �� �  �� � ����   DB  8	 � � �	�	9�	 84 �   
� 


 D�- � !"� D@ � � !#� D� � 8 � � �	�	$9�	 � � $  
� 


%�  D � � !'� D> � � !#� D� � 8 � � �	�	(9�	 � � (  
� 


)�  D �	 ��*�* � ��+9� � � +  
� ,DG ��inheritFrame�Fight�Instance�operationManager�GetMoveEvent�Quat�LookRotationA�x�y�entity�transformComponent�GetRotation�ToEulerAngles�NormalizeEuler�moveEventTime        �cacheAngle�FightUtil�deltaTimeSecond�params�lastAngle�CheckReverGlideState�animState�FightEnum�GlideLoopState�Front�stateComponent�PlayAnimation�Config�EntityCommonConfig�AnimatorNames�GlideLoopFront�math�floor�abs�Right�GlideLoopRight      �?�ceil�Left�GlideLoopLeft �None�GlideLoop�     �������� �� p � �� � �  �  H   H G ���������� ��   �  �  ���������� ��   �  �  ���������� ��   �  �  ���������� ��   �  �  ���������� ��   �  �  ���������� ��   �  �  ���������� ��   ���   ���  � ���  � ��  ��params�rotateOffsetZ        �rotateOffsetX�entity�clientTransformComponent�SetNotUpWithoutStableOnHit�animState ��������� ��   � ���    � �  ��fight�objectPool�Cache�GlideLoopMachine�   ���������