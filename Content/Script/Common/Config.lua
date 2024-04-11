-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-03
-- Description: 客户端配置
-----------------------------------------------------------------------------
Env = {
    Debug = true,
}
deploy_mode = DeployMode.Localhost

if deploy_mode == DeployMode.Online then
    -- Public Server
    Servers = {
        login = {
            [1] = { url = "http://1.14.123.62:10086" },
        },
        pvp_manager = {
            [1] = { ip = "1.14.123.62", port = 20001 },
        }
    }
elseif deploy_mode == DeployMode.Development then
    -- Local Development
    Servers = {
        login = {
            [1] = { url = "http://127.0.0.1" },
        },
        pvp_manager = {
            [1] = { ip = "127.0.0.1", port = 20001 },
        }
    }
elseif deploy_mode == DeployMode.Localhost then
    -- Local Host
    Servers = {
        login = {
            [1] = { url = "http://127.0.0.1:8088" },
        },
        pvp_manager = {
            [1] = { ip = "127.0.0.1", port = 20001 },
        }
    }
else
end


-- 场景地图
Maps = {
    [1] = "/Game/Maps/Game",
}
