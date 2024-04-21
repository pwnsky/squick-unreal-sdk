-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-09-01
-- Description: 玩家信息
-----------------------------------------------------------------------------

Player = Object({})

function Player:Create(net)
    self.net = net
    self.net:RegisteredDelegation(MsgId.IdAckPlayerEnter, self.OnAckPlayerEnter, self)
    self.net:RegisteredDelegation(MsgId.IdAckPlayerData, self.OnAckPlayerData, self)
end

-- 请求进入游戏
function Player:OnConnected()
    print("已连接成功")
    self:ReqPlayerEneter();

end

function Player:ReqPlayerEneter()
    local req = {}
    self.net:SendPB(MsgId.IdReqPlayerEnter, "rpc.ReqPlayerEnter", req )
end

function Player:OnAckPlayerEnter(data)
    print("玩家已进入")
    local ack = assert(pb.decode("rpc.AckPlayerEnter", data))
    PrintTable(ack)
    local player_data = ack.data
    local msg = 'Login success\n Account: ' .. player_data.account
    .. "\nAccountID: " .. player_data.account_id
    .. "\nUid: " .. player_data.uid
    .. "\nName: " .. player_data.name
    .. "\nLevel: " .. player_data.level
    .. "\nIP: " .. player_data.ip
    .. "\nArea: " .. player_data.area
    .. "\nCreatedTime: " .. player_data.created_time
    --.. "\nLastLoginTime: " .. player_data.last_login_time
    --.. "\nLastOfflineTime: " .. player_data.last_offline_time
    --.. "\nPlatform: " .. player_data.platform
    Screen.Print(msg)
    
    GameInstance:LoadLevel("/Game/Maps/Game")
end

function Player:OnAckPlayerData(data)
    print("玩家数据...")
    local ack = assert(pb.decode("rpc.AckPlayerData", data))
    PrintTable(ack)

end