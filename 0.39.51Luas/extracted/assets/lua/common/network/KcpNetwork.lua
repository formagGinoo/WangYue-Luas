LuaT �

xV           (w@��� �Q      B�  �  �   R         �   O  � �   O�  � �   O � �   O� � �   O � �   O� � �   O � �   O� � �   O � 	�   O� � 
�   O � �   O� � �   O � �   O� � �  O � �  O� � �  O � �  O� � �  O	 � �  O�	 � �  O
 � �  O�
 � �  ��� ƀ��KcpNetwork�__init�SetSessionId�SetKcpMode�SetHostAndPort�Go�Stop�Connect�OnConnectSucceed�AddHandler�RemoveHandler�Update�SendPack�RecvPack�HandlerPack�KcpNetwork�PackError�Send�ConnDisconnect�PushByteArray�Disconnect�SetEvent�QueryState�IsConnect�  ���� ��    � �D   R    ��	
  R    ���  ���� � �  DF� ��NetworkDefine�conn�BaseConn�Create�ConnType�udp�sendList�maxSendLen�      �maxRecvNum
       �handlers�tickTimer �lastTickTime        �sessionId�kcpMode�KcpMode�fast�rtt�rto�isRunning�isSendImmediate�SetEvent�KcpConnEvent�disconnect�   ����  �	   �  D G  ��ConnDisconnect�  ������������ �  G ��sessionId��������� �  G ��kcpMode��������� �   � ��host�port��������� ��   � �   � ���� � �   � ��  ��� 8 ��  �  	� ��
���� �  ��NetworkDefine�openKcp�isRunning�IsConnect�conn�Handshake�Facade�GetCtrl�LoginCtrl�SendMsg�   �������� ��   � �   � ���  ��� �  ��NetworkDefine�openKcp�isRunning�conn�Disconnect�   �������� ��    ��  �  D �  �  �  � ��   � �  �  	��
� �  	 � �  	 � �  	���  � �  ��print�string�format�KcpNetwork:Connect(host:[%s], port:[%s], session:[%s])�host�port�sessionId�LogError�KcpNetwork SessionId必须大于0�conn�Disconnect�kcpMode�Connect�   �������� ��   ��� �  ��conn�ConnectSucceed��������� ��  ��  8 ��  �   D � �  �� ��handlers�LogError�string�format�禁止一个消息被多个函数处理[%s]�   �������� �  �G ��handlers ��������� ��   �   � ��� � �� � �� � �  ��isRunning�SendPack�RecvPack�HandlerPack��������� Ձ��  R   �    � DK� 	�	: 8 � � 
 � �	�	#
.�
� 
 : 8 �� #�� ���	���	����	"
.
� � � �  8 ��	�
�
�� 
� 
8��	�	�
 8 � 	

�   D ;� �  �L M� 6    8  �F� 4 � ��J  �	�� ��� 	�	 ��I� F� ��ipairs�sendList�sendLen�maxLen�maxSendLen�conn�Send�byteArray�getPack�table�insert�PushByteArray�id�remove�   �������� ��   ��� �   ��� �  ��conn�OnKcpUpdate�Recv��������� ����  =� 8 �  �  8 � �DB  � �� ��� �� � ��  8 ��  � 4 �� 	��  8 � 
�  �   D� �� �8��G ��maxRecvNum�conn�PopPack�ProtoCodec�Unmarshal�NetworkDefine�KCP_DEBUG�LogFormat�KcpNetwork ProtoCodec:Unmarshal(protoId:[%s], pack length:[%s])�handlers�xpcall�KcpNetwork�PackError�     �������� ��   �  �    � �  ��LogErrorFormat�处理协议报错[%s]%s�     �������� Ў  ���  � ��  ���  8  �� � ���   �  8  �G ����� B  8 ����  R     : 8 �� :	 � ���"	.	� �
 8 � �
.  �
�	�/��	.	D D  
 B  � �"	.	"	.	���� � 
�  R   �D B  � � �
   DG ��conn�IsConnect�IsConnecting�ProtoCodec�Marshal�getAvailable�isSendImmediate�maxSendLen�Send�getPack�table�insert�sendList�id�sendLen        �maxLen�byteArray�NET_DEBUG�Log�发送消息�   �������� ��    � �  �� ���  �  �   �   R    ƀ ��ipairs�sendList�PushByteArray�id�byteArray�   �������� ��  ���  8  �� � ���� � � �� ��NetworkDefine�NotPushPool�PoolManager�Instance�Push�PoolType�class�ByteArray�poolKey�   �������� �  ��   � D D   8 � �  �  DG ��LogColorFormat�KcpNetwork:Disconnect(%s)�tostring�NetworkDefine�DisconnectType�initiative�conn�Disconnect�   �������� ��  ���   �� ��conn�SetEvent��������� ��   �  � ��� �  �  ��Log�网络连接状态�conn�GetState�   �������� ��   � �   � ��  ���  �   �   �  �  ��NetworkDefine�openKcp�conn�IsConnect�   ���������