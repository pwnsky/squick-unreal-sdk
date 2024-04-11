-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: 连接成功后，对游戏对局，玩家数据初始化
-----------------------------------------------------------------------------

GameInit = Object({})

function GameInit:Create(net)
    print("Init Game Init: ", net)
    self.net = net
    self.net:RegisteredDelegation(GameplayManagerRPC.ACK_GAMEPLAY_DATA, self.OnAckGameplayData, self)
end

function GameInit:OnReqGameplayData()
    print("请求服务端游戏数据初始化... ")
    local req = {
        instance_id = ServerArgs.instance_id,
        instance_key = ServerArgs.instance_key,
    }
    self.net:SendPB(GameplayManagerRPC.REQ_GAMEPLAY_DATA, "rpc.ReqGameplayData", req )
end

-- 获取房间内详细信息
function GameInit:OnAckGameplayData(data)
    print("数据初始化中...")
    local ack = assert(pb.decode("rpc.RoomDetails", data))
    PrintTable(ack)
    --print("event_code", ack.event_code, type(ack.event_code))
    -- 进入场景
    print("正在加载场景: ", Maps[ack.game_play.scene])
    GameInstance:LoadLevelAndListen(Maps[ack.game_play.scene], ack.max_players)
end

function GameInit:OnReqGameplayInitPrepared(port)
    print("服务端初始化完成，绑定端口为: ", port)
    local req = {
        code = 0, -- Game Play服务器状态, 0 正常, 1 不正常
        id = ServerArgs.instance_id,
        key = ServerArgs.instance_key,
        ip = ServerArgs.ip,
        port = port,
        name = ServerArgs.name,
    }
    self.net:SendPB(GameplayManagerRPC.REQ_GAMEPLAY_PREPARED, "rpc.ReqGameplayPrepared", req )
end