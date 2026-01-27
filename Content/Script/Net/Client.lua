-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-02
-- Description: 网络管理器，用于监听Protobuf消息事件以及Protobuf消息发送，动态绑定事件与解除等
-----------------------------------------------------------------------------



-- ref: https://www.cfanzp.com/lua-string-pack/
-- ref: https://blog.csdn.net/beyond706/article/details/105949783
-- 采用大端字节序进行编码解码，目前还是小端，之后整改
local HEADER_SIZE = 9 -- 1字节标识位 + 4字节消息ID + 4字节消息长度
function MsgEncode(msg_id, data)
    -- 采用大端来进行包裹
    return 'S' .. string.pack(">I4", msg_id) .. string.pack(">I4", #data) .. data
end

function MsgDecode(raw_data)
    local signature = string.unpack(">I1", raw_data, 1)
    if signature ~= string.byte('S') then
        print("MsgDecode signature error: " .. tostring(signature))
        return true, 0, 0, nil
    end

    local id = string.unpack(">I4", raw_data, 2)
    local size = string.unpack(">I4", raw_data, 6)
    local body = string.sub(raw_data, 10, -1)
    return false, id, size, body
end

NetState = {
    Connecting = 0,
    Connected = 1,
    Disconnected = 2,
}

NetEventType = {
    None = 0,
    Connected = 1,
    Disconnected = 2,
    ConnectionRefused = 3,
    DataReceived = 4,
}


-- NetClient 采用Game Instance来创建的，之后再绑定在 TcpClient Actor之上，再切换场景的时候 TcpClient会销毁断开连接，切换完毕后，继续绑定在该对象上，重新自动会与服务器建立连接。
NetClient = Object({})


function NetClient:Create(type)
    self.delegations = {}
    self.netEventHandlers = {}
    self.isLogined = false
    self.heartBeatIndex = 0
    self.isConnected = false
    self.evnetType = NetEventType.None
    self.events = nil
    self.isReceivedAll = true
    self.isReceivedHeader = false
    self.cacheData = ''
    self.cacheSize = 0
    self.lastHeartbeatTime = 0

    self:RegisteredDelegation(MsgId.IdAckHeartBeat, self.OnAckHeartBeat, self)

    if(type == 'tcp') then
        self.client = Tcp.New(self)
    end
end

-- 包裹最基本的包体
function NetClient:SendData(msgId, data)
    local sendBytes = MsgEncode(msgId, data);
    print("发送数据: " .. pb.tohex(sendBytes))
    self.client:SendData(sendBytes)
    self.cacheData = ''
    self.cacheSize = 0
end

-- TCP层面发送数据
function NetClient:SendRaw(data)
    self.client:SendData(data)
end

-- 最常用接口，提供msgid, protobuf结构体名称， 还有对应的 table 值即可
function NetClient:SendPB(msgId, pkg, tb)
    local data =  assert(pb.encode(pkg, tb))
     self:SendData(msgId,data)
end

function NetClient:OnConnected()
    self.heartBeatIndex = 0
    self.isConnected = true
    local handler = self.netEventHandlers[NetEventType.Connected]
    if  handler then
        handler.callback(handler.this)
    end
end

function NetClient:OnDisconnected()
    self.isConnected = false
    local handler = self.netEventHandlers[NetEventType.Disconnected]
    if  handler then
        handler.callback(handler.this)
    end
end

function NetClient:OnConnectionRefused()
    self.isConnected = false
end

function NetClient:Connect(ip, port)
    print("wanna connect to " .. ip .. tostring(port))
    self.client:Connect(ip, port)
end

-- 只进行事件通知，不提供数据
function NetClient:OnDataReceived(data)

    local ret = self:UnpackMsg(data)
    if ret == 0 then -- 收到完整包
        --print("收到完整包")
    elseif ret == 1 then -- 收到分包
        print("收到分包, 等待完成接收")
    elseif ret == 2 then -- 收到粘包
        print("收到粘包, 已拆解完毕")
    elseif ret == 3 then
        print("收到粘包, 部分包拆解失败")
    elseif ret == 4 then
        print("收到粘包, 包量过大，已丢弃部分包") 
    elseif ret == 5 then
        print("收到粘包, 最后一个包存在分包, 等待接收")
    elseif ret == -1 then
        print("数据包解码错误")
    else -- 
        print("未知错误")
    end
    
end

function NetClient:UnpackMsg(data)
    print("DataReceived data: " .. pb.tohex(data)  )
    -- 头部不完整，继续接受头部
    if self.isReceivedHeader == false then
        if #data == HEADER_SIZE then
            self.cacheData = data
            self.isReceivedHeader = true
            self.isReceivedAll = false
            local is_error, id, size, body = MsgDecode(self.cacheData);
            if is_error then
                return -1
            end
            if (size == 0) then
                self:OnMessageEvent(id, '')
                self.isReceivedAll = true
                return 0
            end
            return 1
        end

        if #data < HEADER_SIZE then
            if Env.Debug == true then
                print("头部不完整")
            end
            
            self.cacheData = data
            return
        elseif #data >= HEADER_SIZE  then
            
            -- 存在头部
            self.isReceivedHeader = true
        elseif self.cacheData then
            if #self.cacheData + #data >= HEADER_SIZE then
                if Env.Debug == true then
                    print("存在头部")
                end
                self.isReceivedHeader = true
            end
        else
            --print("头部未接收完毕")
            self.cacheData = self.cacheData .. data
        end
    end

    -- 分包处理
    if self.isReceivedAll == false then
        -- 如果接收分包总时间大于5秒，将其该全部丢弃掉
        -- 分包处理
        local data_size = #data

        local cache_data_size = #self.cacheData

        if data_size + cache_data_size == self.cacheSize then
            -- 接收分包完成
            self.isReceivedAll = true
            self.cacheData = self.cacheData .. data
            local is_error, id, size, body = MsgDecode(self.cacheData)
            if is_error then
                return -1
            end
            if Env.Debug == true then
                print("收到完整,调用:", id)
            end
            self:OnMessageEvent(id, body)
            self.isReceivedAll = true
        elseif data_size + cache_data_size > self.cacheSize then
            self.cacheData = self.cacheData .. data
            -- 收到的数据多余，直接丢改下面进行处理
            local is_error, id, size, body = MsgDecode(self.cacheData)
            if is_error then
                return -1
            end
            if Env.Debug == true then
                print("收到多余,调用:", id, " cache_size: " .. self.cacheSize, " all size: " .. (data_size + cache_data_size))
            end
            self:OnMessageEvent(id, body)
            
            -- 将剩余的直接交给下面处理
            data = string.sub(self.cacheData, self.cacheSize + 1, -1)
            self.isReceivedAll = true
        else
            if Env.Debug == true then
                print("继续接收分包")
            end
            -- 继续接收分包
            self.cacheData = self.cacheData .. data
        end
    end

    -- 头部还不完整
    if #data < HEADER_SIZE then
        if Env.Debug == true then
            print("头部不完整")
        end
        self.cacheData = data
        self.isReceivedHeader = false
        return
    end

    -- 拆解头部
    local is_error, id, body_size, body = MsgDecode(data)
    if is_error then
        return -1
    end

    local size = body_size + HEADER_SIZE

    if size == #data then
        self.isReceivedAll = true
        self:OnMessageEvent(id, body)
        return 0
    end
    
    -- 还存在，部分数据未接收，等待5秒接收完毕
    --print("收到包含头部的分包 或 出现粘包情况 header_size: ", size, "  net pakage size:", #data)
    if size > #data then
        --print("出现分包", data)
        self.cacheData = data
        self.cacheSize = size
        self.isReceivedAll = false
        return 1
    else
        --print("出现粘包", data)
        for i=1, 1000 do -- 最多一次拆解1000个包，其余丢弃
            local pak = string.sub(data, 1, size)
            local left_data = string.sub(data, size + 1, #data)

            if left_data == nil then
                return 3
            end

            if #pak == size then
                --print("分包调用: ", id, " size: ", #pak)
                local body = string.sub(pak, 10, -1)
                self:OnMessageEvent(id, body)
            end

            local is_error, id, body_size, body = MsgDecode(left_data)
            if is_error then
                return -1
            end
            if body_size == #left_data then -- 最后一个包
                --print("分包最后一个调用: ", id, " size: ", #left_data)
                self.isReceivedAll = true
                self.cacheSize = 0
                local bytes = string.sub(left_data, 10, -1)
                self:OnMessageEvent(id, bytes)
                return 2
            elseif body_size > #left_data then
                -- 分包
                self.cacheData = left_data
                self.cacheSize = size
                self.isReceivedAll = false
                
                return 5
            else 
                -- 还存在粘包，继续拆解
                data = left_data
            end
        end
        return 4
    end
    
    return -1

end


-- 每3秒由 Client 进行调用
function NetClient:OnReqHeartBeat()
    self.heartBeatIndex = self.heartBeatIndex + 1
    self:SendData(MsgId.IdReqHeartBeat, assert(pb.encode("rpc.ReqHeartBeat", { index = self.heartBeatIndex})))
end

-- 服务端返回
function NetClient:OnAckHeartBeat(data)
end

-- 由 Instance 进行Tick驱动
function NetClient:Tick()
    if(self.client) then
        self.client:Tick()
    end

    local time = os.time()
    if time > self.lastHeartbeatTime and self.isConnected then
        self.lastHeartbeatTime = time + 5 --每3秒发送一次心跳
        self:OnReqHeartBeat()
    end
end

-- 收到消息
function NetClient:OnMessageEvent(msgId, data)
    if self.delegations[msgId] == nil then
        print("不存在该Msg, msg id: " .. tostring(msgId))
        --print("data: ", data)
        return
    end

    if Env.Debug == true then
        print("Recived msg id " .. tostring(msgId))
    
    end
    
    local delegation = self.delegations[msgId]
    delegation.callback(delegation.this, data)
end


function NetClient:RegisteredNetEventHandler(event, callback, this)
    self.netEventHandlers[event] = { callback = callback, this = this }
end

-- 注册
function NetClient:RegisteredDelegation(msgId, callback, this)
    if msgId == nil then
        print("MsgID == nil", this)
        dump(this, " NetClient:RegisteredDelegation")
        --PrintTable(this)
    end
    
    self.delegations[msgId] = { callback = callback, this = this }
end

function NetClient:RemoveDelegation(msgId)
    self.delegations[msgId] = nil
end