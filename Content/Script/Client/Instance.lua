-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-04
-- Description: 客户端游戏单例
-----------------------------------------------------------------------------

require "Net.Client"
require "Net.Tcp"
require "Client.Login"
require "Client.Room"
require "Client.Proxy"
require "Client.Player"

-- 在Lua层面创建客户端 Instance 
function GameInstance:Init()
    self.net = NetClient.New('tcp')
    self.Login = Login.New()
    self.Proxy = Proxy.New(self.net)
    self.Player = Player.New(self.net)
    self.Room = Room.New(self.net)
    self.isLogin = false
    self.net:RegisteredNetEventHandler(NetEventType.Connected, self.OnNetConnected, self)
    self.net:RegisteredNetEventHandler(NetEventType.Disconnected, self.OnNetDisConnected, self)
    self:EventBind()

    self.Widgets = { }

    GameInstance:PlayBGM() -- 播放BGM
end

function GameInstance:EventBind()
    
end

function GameInstance:CheckIsLogin()
    
end

function GameInstance:OnLogined(ip, port, account_id)
    --  连接代理服务器
    self.net:Connect(ip, port)
end

-- 第一次运行不会调用，由InstanceEventActor 来进行触发调用
function GameInstance:BeginPlay() 

end

-- 网络连接代理服务器成功
function GameInstance:OnNetConnected()
    print("OnNetConnected")
    -- 请求连接代理服务器
    self.Proxy:OnReqConnectProxy(self.Login.cache)
end

-- 连接代理服务器授权成功
function GameInstance:OnProxyConnected()
    self.Player:OnConnected()
end


-- 客户端进入游戏
function GameInstance:OnEnterLobby()
    Screen.Print("成功进入游戏")
    
    -- 进入游戏
    self:LoadLevel("/Game/Maps/Lobby")
    --self:UIShow_GameMode()
end

-- 网络请求完毕通知
function GameInstance:OnReqFinished()
    
end

-- 连接成功
function GameInstance:OnLoginSecsuss()
    print("登录成功")
    --self.EnterGame:OnReqEnterGame()
end

function GameInstance:OnNetDisconnected()
    
end

function GameInstance:Tick(deltaSeconds)
    if(self.net) then
        self.net:Tick()
    end
end

function GameInstance:EndPlay()
    
end

function GameInstance:OnChangeScene()

end
-----
