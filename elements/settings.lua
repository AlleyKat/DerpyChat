local unpack = unpack
local C,M,L,V = unpack(select(2,...))

local chat = M.make_settings_template("CHAT",250,448)

-- Remake needed
local st = {
	["hide_chat_junk"] = "HIDE CHAT JUNK",
	["hyperlinks_show_brakets"] = "HYPER LINKS BRACKETS",
	["hyperlinks"] = "HYPER LINKS",
	["chatplayer"] = "HIGHLIGHT PLAYER NAME",
	["text_on_right"] = "JUSTIFY RIGHT FRAME"
}
	
local g = M.setfont(chat,21)
g:SetPoint("TOP",0,-14)
g:SetText("FLASHTAB BLACK LIST")	
	
M.addafter(function()
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
				f:SetSize(220,20)
			local b = mk_swich_bt(f,o)
			local a = M.setfont(f,12)
				a:SetText(_G["ChatFrame"..o.."Tab"]:GetText())
				a:SetPoint("LEFT",7,1)
				a:SetPoint("RIGHT",-43,1)
			if o == 1 then
				f:SetPoint("TOP",chat,0,-44)
			elseif o == 3 then
				f:SetPoint("TOP",frames__[o-2],"BOTTOM",0,2)
			else
				f:SetPoint("TOP",frames__[o-1],"BOTTOM",0,2)
			end
			frames__[o] = f
		end
	end
	
	local convo = M.frame(chat,chat:GetFrameLevel()+4,"HIGH")
	convo:SetSize(220,20)
	local b = mk_swich_bt(convo,2)
	local a = M.setfont(convo,12)
	a:SetText("RealID Conversation")
	a:SetPoint("LEFT",7,1)
	a:SetPoint("RIGHT",-43,1)

	convo:SetPoint("TOP",frames__[#V.flash_blacklist],"BOTTOM",0,2)
	
	local num = {"ch_w","ch_max","ch_min"}
	
	local names = {
		["ch_w"] = "CHAT WIDTH",
		["ch_max"] = "CHAT MAX HEIGHT PRESET",
		["ch_min"] = "CHAT MIN HEIGHT PRESET",}
		
	local limits = {
		["ch_w"] = 1000,
		["ch_max"] = 500,
		["ch_min"] = 100,}
		
	local pers	

	for i=1,3 do
		local p = num[i]
		local a = M.makevarbar(chat,238,0,limits[p],V,p,names[p])
		if i == 1 then
			a:SetPoint("TOP",convo,0,-28)
		else
			a:SetPoint("TOP",pers,"BOTTOM")
		end
		pers = a
	end
end)

M.tweaks_mvn(chat,V,st,356)
