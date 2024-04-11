local socket = require("socket")
-- TCP Socket Test

local host = "1.14.123.62"
local file = "/"
local sock = assert(socket.connect(host, 80))  -- 创建一个 TCP 连接，连接到 HTTP 连接的标准 80 端口上
sock:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
--repeat
    local chunk, status, partial = sock:receive(1024) -- 以 1K 的字节块来接收数据，并把接收到字节块输出来
    print(chunk or partial)
--until status ~= "closed"

sock:close()  -- 关闭 TCP 连接