LuaT �

xV           (w@��� �Q     �    D       �       π      �      π     �      π     �   	   π  
   �      π     �      π  F ��ShowTerrainView�BaseClass�BaseView�__init�__Show�__Hide�__CacheObject�PopCube�PushCube�RemoveTimer�ShowTerrainCollider�ShowTerrainInfo�LogicHeight�__delete�__Create�  ���� ���  ��  � �� � ��� ��   R    �   R    	�   �  
�  �  �  �  ���  � �  ��SetAsset�Prefabs/UI/FightDebug/DebugShowTerrain.prefab�SetParent�UIDefine�canvasRoot�transform�showType        �cubeCache�cubeList�terrainDebug�GameObject�TerrainDebug�cubeOrigin�CreatePrimitive�PrimitiveType�Cube�SetActive�   �������� ��  ���������� ���  � �� � �  ��PushCube�RemoveTimer��������� ��   ��� � �� �  ������ � � 
D�� � D D �  � 
D��  D D � � � 
D�� � D D  �� ��	 � D  G ��gameObject�GetComponent�Canvas �pixelPerfect�overrideSorting�Find�ShowTerrainCollider�Button�onClick�AddListener�ToFunc�ShowTerrainInfo�LogicHeight�text�UtilsUI�GetText�LogicHeight/Text�   �������� ��   �  �   � � � D�  � �8 ��	  D  
�   D�  G ��table�remove�cubeCache�GameObject�Instantiate�cubeOrigin�transform�parent�terrainDebug�SetActive�insert�cubeList�   �������� 
��    � �  ���  �� � � ��  �  �   �   R    ƀ ��pairs�cubeList�SetActive�table�insert�cubeCache�   �������� ��   �   � ��  � ���  � � �  ��timer�LuaTimerManager�Instance�RemoveTimer �   �������� ��   ��� 8 ��� � � �    � ��  � ������ �� �� � �   �� 
� �  � �  D� �  �#������� �J" ���� �J� ��� �J �
�
�"
.
D	@	 8 ����
 �	�".�����	�	  � �� D
�
 �
�
 �� �	 �� D�
�
 �	���".��".����D�
I� I  I�" G ��showType�RemoveTimer       �timer�LuaTimerManager�Instance�AddTimer      �?�ToFunc�ShowTerrainCollider�PushCube�Fight�terrain�BehaviorFunctions�GetCtrlEntity�GetPositionP�Center�y�GetHeightIndex      �?�CheckObstacle�x�z�PopCube�transform�parent�terrainDebug�localScale�Vector3�position�   �������� �   ��� 8 ��� � � �    � ��  � ������ �� �� � �   �� 
� �  � �  � D� �������� ��! ������ �ʄ �  R    ���� �J �
 �
0�
�
".�0��D
 D	 �	  8 �
B�  � �
  R   �� D
�
 �
�
 �� � �� D�
�
 �0��".	�0��D�
I� � ɂ! � ��showType�RemoveTimer       �timer�LuaTimerManager�Instance�AddTimer      �?�ToFunc�ShowTerrainInfo�PushCube�BehaviorFunctions�GetCtrlEntity�GetPositionP�Fight�terrain�Center�y�CheckTerrainY�Vector3�x�z�PopCube�transform�parent�terrainDebug�localScale      �?�position�   �������� ��   �   3 � �   � � �   8 ��  �  ��������� � ��  �  ���������� �  ��FightDebugManager�Instance�logicHeight�CustomUnityUtils�SetTextColor�text�   �������� 	��    � �  � �  ��  �  �   �    � �  � �  ��  �  �   �  �  � �  �  � �� � ƀ ��pairs�cubeList�GameObject�Destroy�cubeCache�terrainDebug�cubeOrigin�RemoveTimer�   �������� ��  �����������