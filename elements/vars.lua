-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyChat then
	_G.DerpyChat = {
			
			["text_on_right"] = true,
			["hyperlinks_show_brakets"] = false,
			["hide_chat_junk"] = true,
			["chatplayer"] = true,
			["show_flash"] = true,
			["hyperlinks"] = true,
			["left"] = false,
			["right"] = false,
			
			["right_size"] = 100,
			["chat_speed"] = 60,
			["ch_w"] = 300,
			["ch_max"] = 120,
			["ch_min"] = 48,
			
			["flash_blacklist"] = {
				[1] = false,
				[2] = false,
				[3] = false,
				[4] = false,
				[5] = false,
				[6] = false,
				[7] = false,
				[8] = false,
				[9] = false,
				[10] = false,
			},
			
			["chatcur"] = {
				[1] = 48,
				[2] = 48
			},
		
			["ChatBar"] = {
				{"CHAT_MSG_SAY","SAY","/s ",true},
				{"CHAT_MSG_PARTY","PARTY","/p ",true},
				{"CHAT_MSG_GUILD","GUILD","/g ",true},
				{"CHAT_MSG_RAID","RAID","/raid ",true},
				{"CHAT_MSG_YELL","YELL","/y ",true},
				{"CHAT_MSG_WHISPER","WHISPER","/w ",true},
				{"CHAT_MSG_BATTLEGROUND","BATTLEGROUND","/bg ",true},
			}
	}
end

ns[4] = _G.DerpyChat
