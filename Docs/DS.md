# 对战服

对战服Linux资源消耗:

```
i0gan      18188  0.0  0.0  16452  3988 pts/1    S+   08:48   0:00 /bin/sh ./ActionServer.sh
i0gan      18195  4.3  1.6 2631480 273028 pts/1  Sl+  08:48   0:10 Action/Binaries/Linux/ActionServer Action
```



## Issues



### 2023021102

状态：已解决

执行环境：Arch Linux 运行 Linux专用服务器

描述：专用服务器端口抢占，在后启动的实例，会强行占用7777端口，将之前的实例所绑定的端口好给抢占端口，导致之前的实例又重新绑定一个新的端口。

解决方案：

通过 命令参数 -port来指定端口号，而不是采用程序自主去绑定

https://blog.csdn.net/qq_31930499/article/details/88561678

执行命令：

```
./ActionServer.sh -port=9999
```

日志如下：

```
[2023.02.11-02.45.39:084][ 47]LogGameMode: Display: Match State Changed from EnteringMap to WaitingToStart
[2023.02.11-02.45.39:084][ 47]LogBlueprintUserMessages: [GM_PVP_Team_C_2147482532] GameMode服务端初始化[2023.02.11-02.45.39:084][ 47]LogUnLua: 服务端初始化完成，绑定端口为:   9999
[2023.02.11-02.45.39:084][ 47]LogUnLua: 发送数据: 00 36 00 00 00 30 12 26 1A 0A 34 31 33 38 35 37 33 33 32 33 12 0A 31 36 37 33 38 35 30 37 35 35 2A 09 31 32 37 2E 30 2E 30 2E 31 30 8F 4E 0A 00
[2023.02.11-02.45.39:084][ 47]LogUnLua: GameModeBase Begin
[2023.02.11-02.45.39:084][ 47]LogUnLua: GM_GameChild
[2023.02.11-02.45.39:084][ 47]LogGameState: Match State Changed from EnteringMap to WaitingToStart
```



### 2023021103

状态：未解决

执行环境：Arch Linux 运行 Linux专用服务器

描述：专用服务器执行 QuitGame蓝图无法退出程序



### 2023021105

状态：未解决

执行环境：Windows 和 Android 运行 客户端

描述：采用Linux环境下的UE4打包Linux对战服部署后，再采用Windows环境下的UE4打包Windows和Android，打包出来的客户端无法进入游戏场景。

```
LogHandshake: SendChallengeResponse. Timestamp: 1.990734, Cookie: 250210113042238196043139089177004072009024221039099098099149
LogNet: UPendingNetGame::SendInitialJoin: Sending hello. [UNetConnection] RemoteAddr: 1.14.123.62:38732, Name: IpConnection_19, Driver: PendingNetDriver IpNetDriver_19, IsServer: NO, PC: NULL, Owner: NULL, UniqueId: INVALID
LogNet: Error: UEngine::BroadcastNetworkFailure: FailureType = OutdatedClient, ErrorString = The match you are trying to join is running an incompatible version of the game.  Please try upgrading your game version., Driver = PendingNetDriver IpNetDriver_19
LogNet: Warning: Network Failure: PendingNetDriver[OutdatedClient]: The match you are trying to join is running an incompatible version of the game.  Please try upgrading your game version.
LogNet: NetworkFailure: OutdatedClient, Error: 'The match you are trying to join is running an incompatible version of the game.  Please try upgrading your game version.'
LogNet: UNetConnection::Close: [UNetConnection] RemoteAddr: 1.14.123.62:38732, Name: IpConnection_19, Driver: PendingNetDriver IpNetDriver_19, IsServer: NO, PC: NULL, Owner: NULL, UniqueId: INVALID, Channels: 2, Time: 2023.02.10-22.06.09
LogNet: UChannel::Close: Sending CloseBunch. ChIndex == 0. Name: [UChannel] ChIndex: 0, Closing: 0 [UNetConnection] RemoteAddr: 1.14.123.62:38732, Name: IpConnection_19, Driver: PendingNetDriver IpNetDriver_19, IsServer: NO, PC: NULL, Owner: NULL, UniqueId: INVALID
LogNet: DestroyNamedNetDriver IpNetDriver_19 [PendingNetDriver]
```



预计解决方案：

统一采用Windows环境下源码版UE4的打包所有平台（包括专用服务器）

https://docs.unrealengine.com/4.27/en-US/SharingAndReleasing/Linux/



## 等待优化

玩家连接数限制

减少服务端计算

减小带宽开销

占用内存大小优化

