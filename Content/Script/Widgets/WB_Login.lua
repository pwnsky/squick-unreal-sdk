-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-09
-- Description: 绑定: Lobby/Widgets/WB_Login 蓝图
-----------------------------------------------------------------------------

---@type WB_Login_C
local M = UnLua.Class()

function M:Construct()
	GameInstance.Widgets.Login = self
	self.ButtonLogin.OnClicked:Add(self, M.OnClicked_ButtonLogin)
end

-- 点击登录
function M:OnClicked_ButtonLogin()
    print("ddd")
	-- 账号采用时间戳来区别
	GameInstance.Login:LoginWithAccountPassword("unreal_test_player_" .. string.sub(GameInstance.DeviceID, 0 , 8), tostring(os.time()) )
end

return M