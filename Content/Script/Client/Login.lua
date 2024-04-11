-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-01
-- Description: 登录模块
-----------------------------------------------------------------------------
require "Net.Http"

Login = Object({})

function Login:Create()

    self.cache = {
        account = "none",
        account_id = "",
        password = "",
        limit_time = 0,
        proxy_ip = "",
        proxy_port = 0,
        proxy_key = "",
        proxy_limit_time = 0,
        signatrue = 0,
        login_node = 0,
    }

    self.is_login = false
    self.http = Http.New()
    self.url = Servers.login[1].url
    
end

-- 后面通过向服务器发包检测是否已经登录
function Login:CheckIsLogin()
    return self.is_login
end

function Login:LoginWithAccountPassword(account, password)

    self.cache.account = account
    self.cache.password = password

    local d = {
        type = 0,
        account = account,
        password = password,
        platform = 0,
        device = "windows",
        version = "1.0",
    }

    local r = self.http:PostJson(self.url .. "/login", d)
    if (r == nil) then
        print("网络错误")
        return
    end

    PrintTable(r)

    if(r.code == 0) then
        self.cache.account_id = r.account_id
        print("登录成功\n")
        self.cache.proxy_key = r.key
        self.cache.proxy_ip = r.ip
        self.cache.proxy_limit_time = r.limit_time
        self.cache.proxy_port = r.port
        self.cache.login_node = r.login_node
        self.cache.signatrue = r.signatrue
        GameInstance:OnLogined(r.ip, r.port, r.account_id)
    else
        print("登录失败\n")
    end

end