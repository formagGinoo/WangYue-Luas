LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �   F ��LevelBehavior20400106�SimpleBaseClass�LevelBehaviorBase�__init�GetGenerates�Init�Update�CreateMonster�Die�Death�AddEntitySign�__delete�LevelLookAtPos�StoryEndEvent�  ���� �  G ��fight���������  �  R   �   N  H  �  ��     ��������� �  � �   ���  R   ��	��
�� �  R    R   �� �����  R   �� �����  R   �� ���� R   � � � �  R   �� ���� R    �� � �  R   �� �����  �  R   ��	�� ��!��"# �  R    R   �%� � �  R   �&� � �  $�'(�)	�  ��role�BehaviorFunctions�GetCtrlEntity�mapId��     �logicId�WorldTgc00106�monsterStateEnum�Default        �Live       �Dead       �monsterList�Id �state�bp�Enemy1�entityId�     �patrolList�Enemy2�Enemy3�Enemy3Patrol1�Enemy3Patrol2�Enemy4�Enemy4Patrol1�Enemy4Patrol2�Enemy5�dialogStateEnum�NotPlaying�Playing�PlayOver       �dialogList�Y    IZ    �levelInit�missionState�   �������� 
Ȏ   �  � ��� � � � �  � �  �  � ��  	� 
� �   8 � 	� ��D � ��  �  �	 ��  �   � DK � �	9�	 �  �F� 8 �9 8  ��L M 6  � ��  � � � ��  	� 
 � � �� �8 ��  � � � ��  	� � � ƀ ��levelInit�CreateMonster�monsterList�dialogList�state�dialogStateEnum�NotPlaying�BehaviorFunctions�CheckPlayerInFight�StartStoryDialog�Id�Playing�missionState�ipairs�monsterStateEnum�Dead       �SendTaskProgressV9           �RemoveLevel�G7    �   �������� �  � DK%  � � D� �	�  � 
�	  �
� �	 D
�
 
�	
�		DB  � �  R   �  �˅ � � 	 �	 
 �	 	�	
  
 D	� ͅ �  � ���	  ��� ��
  
 �� ���
   � 
�
L M& 6  F� ��ipairs�BehaviorFunctions�GetTerrainPositionP�bp�mapId�logicId�GetTerrainRotationP�Id�CreateEntity�entityId�x�y�z�levelId�SetEntityEuler�patrolList�table�insert�SetEntityValue�peaceState�patrolPositionList�canReturn�state�monsterStateEnum�Live�   �������� 
��   �� �9	 8 �� �		� � �  Ɓ ��ipairs�monsterList�Id�state�monsterStateEnum�Dead�   �������� �� ���������� �� ���������� ��  ���������� ċ  �  � �  ��  �� � D
�  �  �  �
  �   DB  8 �  	�  � D8 �  	�  D  
�   D�   �    �   D�   �    � D�   �    � DG ��BehaviorFunctions�GetTerrainPositionP�levelId�CreateEntity�x�y�z�DoLookAtTargetImmediately�role�CameraEntityFollowTarget�CameraEntityLockTarget�AddDelayCallByFrame�SetEntityShowState�RemoveEntity�   �������� 
�  � DK	 �  8 � �  � � � �	�	D ��	L M
 6  F� ��ipairs�dialogList�Id�BehaviorFunctions�StartStoryDialog�state�dialogStateEnum�PlayOver�currentDialog �   ���������