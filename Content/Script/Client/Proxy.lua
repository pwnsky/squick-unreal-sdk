-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-03-29
-- Description: 连接服务器代理
-----------------------------------------------------------------------------

Proxy = Object({})

function Proxy:Create(net)
    self.net = net
    self.net:RegisteredDelegation(ProxyRPC.ACK_CONNECT_PROXY, self.OnAckConnectProxy, self)
end

function Proxy:OnReqConnectProxy(data)
    print("请求授权代理服务器: ", data.proxy_key)
    local req = {
        account_id = data.account_id,
        key = data.proxy_key,
        login_node = data.login_node,
        signatrue = data.signatrue,
    }
    self.net:SendPB(ProxyRPC.REQ_CONNECT_PROXY, "rpc.ReqConnectProxy", req )
end

function Proxy:OnAckConnectProxy(data)
    local ack = assert(pb.decode("rpc.AckConnectProxy", data))
    PrintTable(ack)
    if(ack.code == 0) then
        print("连接代理服务器成功")
        GameInstance:OnProxyConnected()
    else
        print("连接代理服务器失败")
    end
end