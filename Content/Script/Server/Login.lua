-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: PVP服务器登录模块，登录成功后，有权访问Game服务器
-----------------------------------------------------------------------------


ServerLogin = Object({})

function ServerLogin:Create(net)
    self.net = net
    self.net:RegisteredDelegation(GameplayManagerRPC.ACK_GAMEPLAY_CONNECT_GAME_SERVER, self.OnAckConnectGameplayManager, self)
    self.cache = {
    }
    self.is_connect = false
    self.game_id = 0
end

-- 后面通过向服务器发包检测是否已经连接
function ServerLogin:CheckIsConnect()
    return self.is_connect
end

function ServerLogin:OnReqConnectGameplayManager(account)
    print("验证key")
    -- 获取连接的key
    local req = {
        id = ServerArgs.instance_id;
        key = ServerArgs.instance_key,
        name = ServerArgs.name,
        security_code = "123",
        platform_type = 0,
        game_id = ServerArgs.game_id, -- game 服务器id
    }
    print("验证Key中") --
    self.net:SendPB(GameplayManagerRPC.REQ_GAMEPLAY_CONNECT_GAME_SERVER, "rpc.ReqGameplayConnectGameServer", req )
end

function ServerLogin:OnAckConnectGameplayManager(data)
    local ack = assert(pb.decode("rpc.AckGameplayConnectGameServer", data))
    print_table(ack)
    if(ack.code == 0) then
        print("连接gameplay manager 成功")
        GameInstance:OnConnectedGameServer()
    end
end
