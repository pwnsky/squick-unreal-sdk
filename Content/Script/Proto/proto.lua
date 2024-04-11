----------------------------------------------------------------------------------
-- don't edit it, generated from .proto files by tools
----------------------------------------------------------------------------------

proto_code = [[
// 描述: 代理服务器RPC
// 使用: 服务器,客户端
syntax = "proto3";
package rpc;

// 8000 ~ 10000
enum ProxyRPC {
    PROXY_RPC_NONE = 0;
    REQ_HEARTBEAT = 8001; // 心跳包
    ACK_HEARTBEAT = 8002; // 代理服务器响应

    REQ_CONNECT_PROXY = 8003;
    ACK_CONNECT_PROXY = 8004;
    REQ_DISCONNECT_PROXY = 8005;
    ACK_DISCONNECT_PROXY = 8006;

    NC_ACK_KICK_OFF = 8010; // 被踢下线
}

message ReqConnectProxy {
    string account_id = 1;
    string key = 2;
    int32 login_node = 3;
    uint64 signatrue = 4;
}

message AckConnectProxy { int32 code = 1; }

message ReqDisconnectProxy {}
message AckDisconnectProxy { int32 code = 1; }

message ReqHeartBeat { int32 index = 1; }

message AckHeartBeat { int32 index = 1; }

message AckKickOff { int64 time = 1; }// 描述: 基础定义
// 使用: 服务器, 客户端

message Vector2 {
    float x = 1;
    float y = 2;
}

message Vector3 {
    float x = 1;
    float y = 2;
    float z = 3;
}

message Vector4 {
    float x = 1;
    float y = 2;
    float z = 3;
    float w = 4;
}

enum ErrorCode {
    ErrCommonSucc = 0;
    ErrCommonFaild = 1;
}

message PlayerData {
    string account = 1;
    string account_id = 2;
    uint64 uid = 3;
    string name = 4;
    int32 level = 5;
    string ip = 6;
    int32 area = 7;
    int32 created_time = 8;
    int32 last_login_time = 9;
    int32 last_offline_time = 10;
    string platform = 11;
}// 描述: 玩家RPC
// 使用: 服务器,客户端

// PlayerRPC 12000 ~ 15000
enum PlayerRPC {
    PLAYER_RPC_NONE = 0;

    REQ_PLAYER_ENTER = 12004;
    ACK_PLAYER_ENTER = 12005;
    REQ_PLAYER_LEAVE = 12006;
    ACK_PLAYER_LEAVE = 12007;

    REQ_PLAYER_DATA = 12002; // 获取玩家详细全部数据
    ACK_PLAYER_DATA = 12003; //
}

message ReqPlayerEnter {
    string account = 1;
    string account_id = 2;
    string ip = 3;
    int32 proxy_node = 4;
    int32 login_node = 5;
    int32 protocol = 6;
    int32 area = 7;
    int32 platform = 8;
    int64 proxy_sock = 9;
}

message AckPlayerEnter {
    int32 code = 1;
    int64 proxy_sock = 2;
    PlayerData data = 3;
}

message ReqPlayerLeave {
}

message AckPlayerLeave {
}

message ReqPlayerData {
}

message AckPlayerData {
    int32 code = 1;
    PlayerData data = 2;
}// 各服务器之间的通信RPC

// Servers RPC 50000 ~ 50200
enum TestRPC {
    TEST_RPC_NONE = 0;

    REQ_TEST_PROXY = 50000;
    ACK_TEST_PROXY = 50001;

    REQ_TEST_GAMEPLAY = 50002;
    ACK_TEST_GAMEPLAY = 50003;

    REQ_TEST_PLAYER_DATA_READ = 50004;
    REQ_TEST_PLAYER_DATA_WRITE = 50005;

}

message Test {
    int32 index = 1;
    int64 req_time = 2;
    bytes data = 3;
}
// 描述: 房间、匹配、副本
// 使用: 服务器, 客户端

// 20000 ~ 22000
enum GameBaseRPC {
    GAME_BASE_RPC_NONE = 0;

    REQ_GAME_START = 20015; // 预留测试用
    ACK_GAME_START = 20016; //
    REQ_GAME_JOIN = 20017;  // 请求加入游戏,在游戏中断线重连时也请求它
    ACK_GAME_JOIN = 20018;
    ACK_GAME_OVER = 20019;    // 游戏结束
    REQ_GAME_RESTART = 20020; // 重新开始游戏
    ACK_GAME_RESTART = 20021;

    // 场景对象
    ACK_GAME_PLAYER_ENTER = 20100; // 对象在服务端上创建成功
    ACK_GAME_PLAYER_LEAVE = 20102; //
}

// 进入游戏
message ReqGameJoin {}

message AckGameJoin { int32 code = 1; }

message AckGameStart { int32 code = 1; }

// 重新开局
message ReqGameRestart {}

message AckGameRestart { int32 code = 1; }

message PlayerBaseInfo {
    bytes guid = 1;
    int32 index = 2;
    bytes account = 3;
    bytes name = 4;
    int32 mask = 5;
    int32 glove = 6;
}

message AckPlayerEnterList // 同场景同房间 玩家进入时列表
{
    repeated PlayerBaseInfo list = 1;
}

message AckPlayerLeaveList // 同场景同房间 离开时列表
{
    repeated bytes list = 1;
}

// 18000 ~ 20000 : game.proto
enum GameRPC {
    GAME_RPC_NONE = 0;
    // 房间逻辑
    REQ_ROOM_CREATE = 18000;
    ACK_ROOM_CREATE = 18001;

    REQ_ROOM_DETAILS = 18002;
    ACK_ROOM_DETAILS = 18003;

    REQ_ROOM_JOIN = 18004;
    ACK_ROOM_JOIN = 18005;
    REQ_ROOM_QUIT = 18006; // 离开房间
    ACK_ROOM_QUIT = 18007;
    REQ_ROOM_LIST = 18008; // 获取房间列表
    ACK_ROOM_LIST = 18009; //

    REQ_ROOM_PLAYER_EVENT = 18010; // 在房间里互动以及事件，广播形式发送给房间内所有玩家
    ACK_ROOM_PLAYER_EVENT = 18011;

    // 开始游戏
    REQ_ROOM_GAME_PLAY_START = 18012; // 请求多人在线游戏，需要提前创建好房间
    ACK_ROOM_GAME_PLAY_START = 18013;

    REQ_ROOM_CREATE_ROBOT = 18014; // 创建机器人
    ACK_ROOM_CREATE_ROBOT = 18015;

    // 玩家匹配
}

// 客户端请求创建房间
message ReqRoomCreate {
    bytes name = 1;
    int32 map_id = 2; // 地图id
}

message AckRoomCreate {
    int32 code = 1;
    int32 room_id = 2;
}

// 请求加入房间
message ReqRoomJoin { int32 room_id = 1; }

message AckRoomJoin {
    int32 code = 1;
    bytes player = 2;
}

// 请求退出房间
message ReqRoomQuit { int32 room_id = 1; }

message AckRoomQuit {
    int32 code = 1;
    bytes player = 2;
}

enum RoomStatus {
    ROOM_PREPARING = 0;    // 玩家准备中
    ROOM_PREPARED = 1;     // 玩家已准备
    ROOM_GAME_PLAYING = 2; // 游戏中
}

message RoomSimple {
    int32 id = 1;          // 房间id
    bytes name = 2;        // 房间名称
    bytes game_mode = 3;   // 游戏模式
    RoomStatus status = 4; // 房间状态
    int32 nplayers = 5;    // 当前房间内玩家人数
    int32 max_players = 6; // 最多人数
}

enum RoomPlayerStatus {
    ROOM_PLAYER_STATUS_NOT_PREPARE = 0; // 未准备
    ROOM_PLAYER_STATUS_PREPARED = 1;    // 已准备
}

message RoomPlayer {
    bytes guid = 1;
    bytes name = 2;
    RoomPlayerStatus status = 3;
}

// 玩家获取房间列表
message ReqRoomList {
    int32 start = 1;
    int32 limit = 2;
}

message AckRoomList { repeated RoomSimple list = 1; }

// 请求获取房间详细信息
message ReqRoomDetails { int32 room_id = 1; }

message RoomDetails {
    int32 id = 1;                    // 房间id
    bytes name = 2;                  // 房间名称
    bytes owner = 3;                 // 房主
    RoomStatus status = 4;           // 房间状态
    int32 nplayers = 5;              // 当前房间内玩家人数
    int32 max_players = 6;           // 最多人数
    repeated RoomPlayer players = 7; // 房间内所有玩家
    RoomGamePlay game_play = 8;      // play信息
}

message AckRoomDetails { RoomDetails room = 1; }

// Game Play 响应结构
message RoomGamePlay {
    int32 id = 1;
    bytes key = 2;
    bytes name = 3;
    bytes ip = 4;
    int32 port = 5;
    int32 scene = 6;
    int32 mode = 7;
    int32 nrobots = 8;
}

// 请求开始游戏
message ReqRoomGamePlayStart { int32 room_id = 1; }

// 如果是已经在房间里的人，开始游戏创建PVP服务器后，会自动通知房间里的其他玩家。
message AckRoomGamePlayStart {
    int32 code = 1;
    RoomGamePlay game_play = 2;
}

message ReqRoomCreateRobot { int32 amount = 1; }

message AckRoomCreateRobot { int32 code = 1; }

]]