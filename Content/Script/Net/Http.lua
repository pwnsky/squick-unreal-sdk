local http = require "socket.http"
local ltn12 = require "ltn12"
local rapidjson = require "rapidjson"


Http = Object({})

function Http:Create()
    self.cookie = "none"
end

function Http:Get(url)
    local respbody = {}
    local body, code, headers, status = http.request {
        method = "GET",
        url = url,
        headers = {
            ["Accept"] = "*/*",
            ["Accept-Encoding"] = "gzip, deflate",
            ["Accept-Language"] = "en-us",
            ["Cookie"] = self.cookie,
        },
        sink = ltn12.sink.table(respbody)
    }
    return respbody[1]
end

function Http:Post(url, data)
    local respbody = {}
    local body, code, headers, status = http.request {
        method = "POST",
        url = url,
        source = ltn12.source.string(data),
        headers = {
            ["Accept"] = "*/*",
            ["Accept-Encoding"] = "gzip, deflate",
            ["Accept-Language"] = "en-us",
            ["Content-Length"] = string.len(data),
            ["Cookie"] = self.cookie,
        },
        sink = ltn12.sink.table(respbody)
    }
    -- Try Set-Cookie
    if(headers == nil) then
        print("network error");
        return nil;
    end

    local cookie = headers['set-cookie']
    if(cookie) then
        self.cookie = cookie;
    end
    return respbody[1]
end

-- string to json table
function Http:PostJson(url, json_data)
    local data = rapidjson.encode(json_data)
    local body = self:Post(url, data)
    if(body) then
        return rapidjson.decode(body)
    end
    
    return nil
end

function Http:GetJson(url)
    local body = self:Get(url)
    if(body) then
        return rapidjson.decode(body)
    end
    return nil
end