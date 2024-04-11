-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: Server Instance
-----------------------------------------------------------------------------
-- 该服务器是由 PVP Manager服务器进行启动，在启动时设定了几个重要的启动参数如下
-- instance_id : 实例id
-- instance_key : 连接key
-- game_id : 游戏服务器id
-- mip : PVP Manager服务器IP
-- mport : PVP Manager服务器端口
-- ip : PVP 服务器IP地址
--------
-- 在启动后，该PVP服务器自主连接 PVP Manager，让PVP Manager作为代理，与Game Server进行通信
-- 在Lua层面创建客户端 Instance 
-- Windows启动参数如下
-- start ../../client/Build/Server/Action.exe -instance_id=123456 -key=abcd -game_id=16001 -mip=192.168.0.196 -mport=20001 -ip=192.168.0.196
require "Net.Client"
require "Net.Tcp"
require "Server.GameInit"
require "Server.Login"
ServerArgs = nil

-- 在Lua层面创建服务端 Instance
function GameInstance:Init(args)
    print("App ARGS: ")
    PrintTable(args)
    local args_table = args:ToTable()
    self.is_local = true

    ServerArgs = {
        instance_id = 0,
        instance_key = "4138573323",
        game_id = 1000,
        mip = "127.0.0.1",
        mport = 12000,
        ip = "127.0.0.1",
        name = "test_gameplay_ds",
    }

    if args_table.instance_id ~= nil then
        ServerArgs.instance_id =  tonumber(args_table.instance_id)
    end
    if args_table.instance_key ~= nil then
        ServerArgs.instance_key = args_table.instance_key
    end
    if args_table.game_id ~= nil then
        ServerArgs.game_id = tonumber(args_table.game_id)
    end
    if args_table.mip ~= nil then
        ServerArgs.mip = args_table.mip
    end
    if args_table.mport ~= nil then
        ServerArgs.mport = tonumber(args_table.mport)
    end
    if args_table.ip ~= nil then
        ServerArgs.ip = args_table.ip
    end

    print("Server ARGS: ")
    PrintTable(ServerArgs)


    -- 脱网测试
    print("self.is_local: ", self.is_local)
    print("dddd")
    if(self.is_local) then
        
        -- 加载地图并监听
        GameInstance:LoadLevelAndListen(Maps[1], 10)
        return;
    end

    self.net = NetClient.New('tcp')
    self.Login = ServerLogin.New(self.net)
    self.GameInit = GameInit.New(self.net)
    self.net:RegisteredNetEventHandler(NetEventType.Connected, self.OnNetConnected, self)
    self.net:RegisteredNetEventHandler(NetEventType.Disconnected, self.OnNetDisConnected, self)

    self:EventBind()
    -- PVP Manager连接服务器
    self:ConnectToServer()
end

function GameInstance:EventBind()
    
end

function GameInstance:OnLoadScene()
    
end

-- 第一次运行不会调用，由InstanceEventActor 来进行触发调用
function GameInstance:BeginPlay() 
    
end

function GameInstance:ConnectToServer()
    print("Connect to Server")
    self.net:Connect(ServerArgs.mip, tonumber(ServerArgs.mport))
end

function GameInstance:BeginPlay()

end

function GameInstance:OnNetConnected()
    print("Connected")
    self.Login:OnReqConnectGameplayManager()
end

function GameInstance:OnNetDisConnected()
    print("OnNetDisConnected")
end

-- 网络请求完毕通知
function GameInstance:OnReqFinished()
    
end

-- 验证key，成功后 Gameplay Manager 充当代理服务器，可直接发包至 Game Server
function GameInstance:OnConnectedGameServer()
    print("OnConnectedGameServer")
    -- 向game server 获取游戏对局数据，并初始化
    self.GameInit:OnReqGameplayData()
end

function GameInstance:OnNetDisconnected()
    
end

function GameInstance:Tick(deltaSeconds)
    if  self.tcp ~= nil then
        self.tcp:Tick()
    end
end

function GameInstance:EndPlay()
    
end

-----
