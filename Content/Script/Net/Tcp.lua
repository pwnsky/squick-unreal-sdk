-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-16
-- Description: 将Lua Socket绑定在 UE4 Actor中，实现Tick检测包状态，采用UE4主线程来发送和接收数据包，避免在切换场景时断线重连以及线程创建和销毁的性能开销。
-----------------------------------------------------------------------------

Tcp = Object({})
local socket = require("socket")

function Tcp:Create(netClient)
    self.netClient = netClient
    self.ip = ''
    self.port = 0
    self.timer = os.time() -- 心跳定时器
    self.socket = nil
end

function Tcp:Connect(ip, port)
    Screen.Print("连接服务器: id " .. ip .. " : " .. tostring(port) )
    self.ip = ip
    self.port = port
    self.socket = socket.connect(ip, port)

    if self.socket ~= nil then
        self.socket:settimeout(0) -- 设置timeout 时间为0
        self:OnConnected()
    else
        self:OnDisconnected()
    end
end

function Tcp:OnDisconnected()
    Screen.Print("断开连接: id " )
    self.isConnected = false
    if self.netClient then
        self.netClient:OnDisconnected()
    end
end

function Tcp:OnConnected()
    self.isConnected = true
    Screen.Print("连接成功: id ")
    if self.netClient then
        self.netClient:OnConnected()
    end
end

function Tcp:SendData(data)
    if self.isConnected == false then
        print("未连接服务器，发送失败")
        return
    end
    assert(self.socket:send(data))
end

function Tcp:OnReceived(data)
    -- 解包
    if self.netClient then
        self.netClient:OnDataReceived(data)
    end
end

-- 通过外界Tick来驱动网络接收
function Tcp:Tick()
    if self.isConnected == true then
        local chunk, status, partial = self.socket:receive(1024) 
        if status ~= "closed" then
            if chunk then
                if #chunk > 0 then
                    self:OnReceived(chunk)
                end
            else
                if #partial > 0 then
                    self:OnReceived(partial)
                end
            end
        else
            self:OnDisconnected()
        end
    end
end

return Tcp


