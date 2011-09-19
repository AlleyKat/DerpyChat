local C,M,L,V = unpack(select(2,...))
local lang_st
local chatbar_table = V.ChatBar

local chatbar = M.frame(UIParent,22)
chatbar:SetPoint("RIGHT",SecondFrameChat.work_unit,"LEFT",2,0)
chatbar:SetHeight(24)

local fade_chan_name = CreateFrame ("Frame",nil,UIParent)
fade_chan_name:SetScript("OnUpdate", FadingFrame_OnUpdate)
fade_chan_name.fadeInTime = .25
fade_chan_name.fadeOutTime = .25
fade_chan_name.holdTime = 2
fade_chan_name:Hide()
fade_chan_name:SetFrameStrata("TOOLTIP")
fade_chan_name:SetFrameLevel(10)

local _t = M.setfont(fade_chan_name,18,nil,nil,"CENTER")

local run_text = function(unchor)
	fade_chan_name:Hide()
	_t:SetPoint("BOTTOM",unchor,"TOP",0,6)
	_t:SetText(unchor.chan_text)
	local r,g,b = unchor:GetBackdropColor()
	_t:SetTextColor(r,g,b)
	FadingFrame_Show(fade_chan_name)
end

local bt_holder = CreateFrame("Frame",nil,chatbar)
bt_holder:SetFrameLevel(40)

local mk_fade_bt = function(self,r,g,b)
	local a = CreateFrame("Frame",nil,self)
	a:SetBackdrop(M.bg)
	a:SetBackdropColor(r,g,b,1)
	a:SetBackdropBorderColor(r,g,b,1)
	a:SetPoint("TOPLEFT",-2,2)
	a:SetPoint("BOTTOMRIGHT",2,-2)
	a:SetScript("OnUpdate", FadingFrame_OnUpdate)
	a.fadeInTime = .1
	a.fadeOutTime = .3
	a.holdTime = .2
	a:Hide()
	self.anim_fl = a
end

local get_color = function(chan)
	return ChatTypeInfo[chan].r,ChatTypeInfo[chan].g,ChatTypeInfo[chan].b
end

local event_function = function(self,_,_,_,_,_,_,_,_,num) 
	if self.num_ch then if self.num_ch ~= num then return end end
	FadingFrame_Show(self.anim_fl) 
end

local tosay_function = function(self) ChatFrame_OpenChat(self.tosay, SELECTED_DOCK_FRAME) end

local setbutton = function(event,chan,tosay,enable,num)
	if not enable then return end
	local frame = CreateFrame("Frame",nil,bt_holder)
	frame:SetHeight(12)
	frame:SetBackdrop(M['bg'])
	local r,g,b = get_color(chan)
	frame:SetBackdropColor(r,g,b,.88)
	frame:SetBackdropBorderColor(r,g,b,.9)
	frame:EnableMouse(true)
	mk_fade_bt(frame,r,g,b)
	if num then
		frame.num_ch = num
		frame.chan_text = lang_st[num]
	else
		frame.chan_text = _G[chan]
	end
	frame:SetScript("OnEvent",event_function)
	frame:RegisterEvent(event)
	frame.tosay = tosay
	frame:SetScript("OnMouseDown",tosay_function)
	frame:SetScript("OnEnter",run_text)
	return frame
end

local all_buttons = {}
local update_time = CreateFrame("Frame")
update_time:Hide()
local correct_width = function()
	local a = #all_buttons
	local x = (chatbar:GetWidth()-16-2*(a-1))/a
	for i = 1,a do
		all_buttons[i]:SetWidth(x)
	end
end

local n = 1
update_time:SetScript("OnUpdate",function(self,t)
	n = n - t
	if n > 0 then return end
	self:Hide()
	correct_width()
	UIFrameFadeIn(bt_holder,.8,0,1)
end)

SecondFrameChat.update_w = function(mode)
	if mode == 1 then
		chatbar:SetPoint("LEFT",SecondFrameChat.copyb,"RIGHT",-2,0)
	else
		chatbar:SetPoint("LEFT",SecondFrameChat.copyb)
	end
	UIFrameFadeOut(bt_holder,.4,1,0)
	n = 1
	update_time:Show()
end

local add_chanel = function(num)
	local temp
	for i = 8, #chatbar_table do
		if chatbar_table[i] then
			local check = chatbar_table[i][5] or 0
			if check == num then return end
		else
			temp = i
		end
	end
	chatbar_table[temp or (#chatbar_table+1)] = {"CHAT_MSG_CHANNEL","CHANNEL"..num,"/"..num.." ",true,num}
end
	
--load and check
M.addafter(function()
	lang_st = M.lang_st
	for i in pairs(lang_st) do
		add_chanel(i)
	end
	for i=8, #chatbar_table do
		if chatbar_table[i] then
			local p = chatbar_table[i][5]
			local x
			for d in pairs(lang_st) do
				if d == p then x = true end
			end
			if not(x) then
				chatbar_table[i] = nil
			end
		end
	end
	for i=1,#chatbar_table do
		if chatbar_table[i] then
			local y = setbutton(unpack(chatbar_table[i]))
			if y then tinsert(all_buttons,y) end
		end
	end
	for i=1,#all_buttons do
		if i == 1 then
			all_buttons[i]:SetPoint("LEFT",chatbar,8,0)
		else
			all_buttons[i]:SetPoint("LEFT",all_buttons[i-1],"RIGHT",2,0)
		end
	end
end)

local st_colors = M["media"].button
local ccheck = function(self)
	if chatbar_table[self.num][4] == true then
		self:SetBackdropColor(unpack(st_colors[2]))
		self:SetBackdropBorderColor(unpack(st_colors[2]))
	else
		self:SetBackdropColor(unpack(st_colors[1]))
		self:SetBackdropBorderColor(unpack(st_colors[1]))
	end
end

local push = function(self)
	if chatbar_table[self.num][4] == true then
		chatbar_table[self.num][4] = false
	else
		chatbar_table[self.num][4] = true
	end
	ccheck(self)
end

local mk_swich_bt = function(frame,p)
	local bt = CreateFrame("Frame",nil,frame)
	bt:SetFrameLevel(frame:GetFrameLevel()+4)
	bt:SetSize(46,12.9)
	bt:SetBackdrop(M.bg)
	bt:SetPoint("RIGHT",-8,0)
	bt:SetFrameStrata("HIGH")
	bt.num = p
	ccheck(bt)
	bt:EnableMouse(true)
	bt:SetScript("OnMouseDown",push)
	return frame
end

local mk_ch_border = function(par,chan,name,p)
	local f = M.frame(par,par:GetFrameLevel()+4,"HIGH")
	f:SetSize(200,25)
	local r,g,b = get_color(chan)
	f:SetBackdropBorderColor(r,g,b)
	f.top:SetTexture(r,g,b)
	f.bottom:SetTexture(r,g,b)
	f.left:SetTexture(r,g,b)
	f.right:SetTexture(r,g,b)
	local t = M.setfont(f,13)
	t:SetPoint("LEFT",7.3,.4)
	t:SetPoint("RIGHT",-62,.4)
	t:SetText(name)
	t:SetTextColor(r,g,b)
	return mk_swich_bt(f,p)
end

local bar
M.call.chatbar = function()
	if bar then bar:Show() return end
	local st = {}
	bar = M.make_settings(st,st,207,230,"TEH CHATBAR",true)
	for i=1,7 do
		local c = chatbar_table[i][2]
		local f = mk_ch_border(bar,c,_G[c],i)
		if i == 1 then
			f:SetPoint("TOP",0,-27)
		else
			f:SetPoint("TOP",st[i-1],"BOTTOM",0,-2)
		end
		st[i] = f
	end
	local temp = 8
	for i=8, #chatbar_table do
		if chatbar_table[i] then
			local n = chatbar_table[i][5]
			local f = mk_ch_border(bar,"CHANNEL"..n,lang_st[n],i)
			f:SetPoint("TOP",st[temp-1],"BOTTOM",0,-2)
			st[temp] = f
			temp = temp + 1
		end
	end
	bar:SetHeight((#st+2)*27)
	bar:Show()
end
