local C,M,L,V = unpack(select(2,...))

local chat
M.call.chat = function()
	if chat then chat:Show() return end
		local names = {
			["ch_w"] = "Chat Width",
			["ch_max"] = "Chat Max Height",
			["ch_min"] = "Chat Min Height",}
		local st = {
			["chat"] = "Enable",
			["hide_chat_junk"] = "Hide Chat Msg",
			["hyperlinks_show_brakets"] = "Hyper Links Brakets",
			["hyperlinks"] = "Hyper Links",
			["chatplayer"] = "Hilight Player Name",
			["text_on_right"] = "Justify Right Frame"}
		chat = M.make_settings(st,V,314,230,"CHAT FRAMES",true)
	------------------- this part req to remake
	local st_colors = M["media"].button
	local ccheck = function(self)
		if V.flash_blacklist[self.num] == true then
			self:SetBackdropColor(unpack(st_colors[2]))
			self:SetBackdropBorderColor(unpack(st_colors[2]))
		else
			self:SetBackdropColor(unpack(st_colors[1]))
			self:SetBackdropBorderColor(unpack(st_colors[1]))
		end
	end
	local push = function(self)
		if V.flash_blacklist[self.num] == true then
			V.flash_blacklist[self.num] = false
		else
			V.flash_blacklist[self.num] = true
		end
		ccheck(self)
	end
	local mk_swich_bt = function(frame,p)
		local bt = CreateFrame("Frame",nil,frame)
			bt:SetFrameLevel(frame:GetFrameLevel()+4)
			bt:SetSize(35,11)
			bt:SetBackdrop(M.bg)
			bt:SetPoint("RIGHT",-8,0)
			bt.num = p
			ccheck(bt)
			bt:EnableMouse(true)
			bt:SetScript("OnMouseDown",push)
		return frame
	end
	local frames__ = {}
	for o = 1, #V.flash_blacklist do
		if o ~= 2 then
			local f = M.frame(chat,chat:GetFrameLevel()+4,"HIGH")
				f:SetSize(200,20)
			local b = mk_swich_bt(f,o)
			local a = M.setfont(f,12)
			a:SetText(_G["ChatFrame"..o.."Tab"]:GetText())
			a:SetPoint("LEFT",7,1)
			a:SetPoint("RIGHT",-43,1)
			if o == 1 then
				f:SetPoint("TOP",chat,0,-47)
			elseif o == 3 then
				f:SetPoint("TOP",frames__[o-2],"BOTTOM",0,2)
			else
				f:SetPoint("TOP",frames__[o-1],"BOTTOM",0,2)
			end
			frames__[o] = f
		end
	end
	local convo = M.frame(chat,chat:GetFrameLevel()+4,"HIGH")
		convo:SetSize(200,20)
		local b = mk_swich_bt(convo,2)
		local a = M.setfont(convo,12)
		a:SetText("RealID Conversation")
		a:SetPoint("LEFT",7,1)
		a:SetPoint("RIGHT",-43,1)
		convo:SetPoint("TOP",frames__[#V.flash_blacklist],"BOTTOM",0,2)
	local g = M.setfont(frames__[1])
	g:SetPoint("BOTTOMLEFT",frames__[1],"TOPLEFT",7,4)
	g:SetText("FLASHTAB BLACK LIST: ")
	------------- end
		local limits = {
			["ch_w"] = 1000,
			["ch_max"] = 500,
			["ch_min"] = 100,}
		local c = 1
		local pers
		for p,t in pairs(names) do
			local a = M.makevarbar(chat,230,0,limits[p],V,p,t)
			if c == 1 then
				a:SetPoint("TOP",convo,0,-24)
				c = nil
			else
				a:SetPoint("TOP",pers,"BOTTOM")
			end
			pers = a
		end
		chat:Show()
end
