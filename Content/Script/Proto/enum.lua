----------------------------------------------------------------------------------
-- don't edit it, generated from .proto files by tools
----------------------------------------------------------------------------------

ErrorCode = {
  ErrCommonSucc = 0, ErrCommonFaild = 1, 
}

GameBaseRPC = {
  GAME_BASE_RPC_NONE = 0, REQ_GAME_START = 20015, ACK_GAME_START = 20016, REQ_GAME_JOIN = 20017, 
  ACK_GAME_JOIN = 20018, ACK_GAME_OVER = 20019, REQ_GAME_RESTART = 20020, 
  ACK_GAME_RESTART = 20021, ACK_GAME_PLAYER_ENTER = 20100, ACK_GAME_PLAYER_LEAVE = 20102, 
}

GameRPC = {
  GAME_RPC_NONE = 0, REQ_ROOM_CREATE = 18000, ACK_ROOM_CREATE = 18001, REQ_ROOM_DETAILS = 18002, 
  ACK_ROOM_DETAILS = 18003, REQ_ROOM_JOIN = 18004, ACK_ROOM_JOIN = 18005, REQ_ROOM_QUIT = 18006, 
  ACK_ROOM_QUIT = 18007, REQ_ROOM_LIST = 18008, ACK_ROOM_LIST = 18009, 
  REQ_ROOM_PLAYER_EVENT = 18010, ACK_ROOM_PLAYER_EVENT = 18011, REQ_ROOM_GAME_PLAY_START = 18012, 
  ACK_ROOM_GAME_PLAY_START = 18013, REQ_ROOM_CREATE_ROBOT = 18014, ACK_ROOM_CREATE_ROBOT = 18015, 
}

RoomStatus = {
  ROOM_PREPARING = 0, ROOM_PREPARED = 1, ROOM_GAME_PLAYING = 2, 
}

RoomPlayerStatus = {
  ROOM_PLAYER_STATUS_NOT_PREPARE = 0, ROOM_PLAYER_STATUS_PREPARED = 1, 
}

MsgId = {
  MsgIdZero = 0, IdReqConnectProxy = 8003, IdAckConnectProxy = 8004, IdReqDisconnectProxy = 8005, 
  IdAckDisconnectProxy = 8007, IdReqHeartBeat = 8008, IdAckHeartBeat = 8009, IdAckKickOff = 8010, 
  IdReqPlayerEnter = 12004, IdAckPlayerEnter = 12005, IdReqPlayerLeave = 12006, 
  IdAckPlayerLeave = 12007, IdReqPlayerData = 12008, IdAckPlayerData = 12009, 
}

TestRPC = {
  TEST_RPC_NONE = 0, REQ_TEST_PROXY = 50000, ACK_TEST_PROXY = 50001, REQ_TEST_GAMEPLAY = 50002, 
  ACK_TEST_GAMEPLAY = 50003, REQ_TEST_PLAYER_DATA_READ = 50004, 
  REQ_TEST_PLAYER_DATA_WRITE = 50005, 
}

