local C,M,L,V = unpack(select(2,...))
local text_on_right = V.text_on_right

-- Chat holders
C.FirstFrameChat = M.frame(UIParent,2,nil,nil,nil,nil,"FirstFrameChat")
local chatone = C.FirstFrameChat
	chatone:SetPoint("BOTTOMLEFT",2,2)
	chatone:SetWidth(V.ch_w)
	
C.SecondFrameChat = M.frame(UIParent,2,nil,nil,nil,nil,"SecondFrameChat")
local chattwo = C.SecondFrameChat
	chattwo:SetPoint("BOTTOMRIGHT",-2,2)
	chattwo:SetWidth(V.ch_w)

-- Bnet toast fix
BNToastFrame:HookScript("OnShow", function()
	BNToastFrame:ClearAllPoints()
	BNToastFrame:SetPoint("BOTTOM",chatone,"TOP",0,20)
end)

M.setbackdrop(BNToastFrame)
M.style(BNToastFrame,true)
BNToastFrame:SetBackdropColor(.08,.08,.08,.9)
BNToastFrameCloseButton:SetAlpha(0)
BNToastFrameCloseButton.SetAlpha = M.null

-- Chat swichng system
if V.ch_max < V.ch_min then
	local a = V.ch_max
	V.ch_max = V.ch_min
	V.ch_min = a
end

if V.ch_max == V.ch_min then
	V.ch_max = V.ch_max + 10
end

local max_h = V.ch_max
local min_h = V.ch_min
local speed = V.chat_speed

-- current
local n = {
	[1] = V.chatcur[1],
	[2] = V.chatcur[2], }

local ponti = CreateFrame("Frame")
ponti:SetFrameStrata("MEDIUM")

local strelki = ponti:CreateFontString(nil,"OVERLAY")
strelki:SetFont(M['media'].font_s,36)
ponti:SetScale(2)
strelki:SetPoint("TOP",.3,-4)
strelki:SetTextColor(1,.7,.1)

strelki.yay = strelki:CreateAnimationGroup("IN")
strelki.yay_ = strelki:CreateAnimationGroup("OUT")

do
	local ti = strelki.yay
	for i = 1,2 do
		M.anim_alpha(ti,i == 1 and "c" or "d",i,.6*(i-1),2*(i-1)-1)
		M.anim_trans(ti,i == 1 and "a" or "b",i,.6*(i-1))
	end
	local to = strelki.yay_
		M.anim_alpha(to,"c",1,.6,-1)
		M.anim_trans(to,"a",1,.6)
	to:SetScript("OnFinished",function() ponti:Hide() end)	
end
	
local to_move = function (self,t)
	n[self.num] = n[self.num] + t * self.mod
	if self.change*n[self.num] < self.level_t*self.change then
		self.target:SetHeight(n[self.num])
	else
		self:Hide()
		n[self.num] = self.level_t
		self.target:SetHeight(self.level_t)
	end
end

local direct = function(num)
	if V.chatcur[num] == max_h
		then 	strelki:SetText('\\/ \\/ \\/')
				strelki.yay_.a:SetOffset(0,-60)
				strelki.yay.b:SetOffset(0,-60)
				strelki.yay.a:SetOffset(0,60)
	else
		strelki:SetText('/\\ /\\ /\\')
		strelki.yay_.a:SetOffset(0,60)
		strelki.yay.b:SetOffset(0,60)
		strelki.yay.a:SetOffset(0,-60)
	end
end

local make_ud = function(frame,num,change,level)
	local f = CreateFrame("Frame")
	f:Hide()
	f.level_t = level
	f.target = frame
	f.num = num
	f.mod = speed * change
	f.change = change
	f:SetScript("OnUpdate",to_move)
	return f
end

local fr_button
local mk_frbutton = function(frame,num)
	frame:SetHeight(V.chatcur[num])
	local bt = CreateFrame("Frame",nil,frame)
	if num == 2 then
		fr_button = bt
	end
	bt:SetFrameStrata("MEDIUM")
	bt:SetPoint("TOPLEFT",frame.top,-2,5)
	bt:SetPoint("BOTTOMRIGHT",frame.top,2,-5)
	bt:EnableMouse(true)
	bt.wait = true
	
	strelki.yay:SetScript("OnFinished",function()
		if not(GetMouseFocus()) then return end
		if GetMouseFocus().wait ==  true then return end
		strelki.yay_:Play()
	end)	
	bt:SetScript("OnEnter",function(self) 
		M.backcolor(frame,1,.7,.1,.4)
		ponti:ClearAllPoints()
		ponti:SetAllPoints(frame)
		direct(self.num)
		ponti:Show()
		strelki.yay_:Stop()
		if not (strelki.yay:IsPlaying()) then
			strelki.yay:Play()
		end
	end)
	bt:SetScript("OnLeave",function() 
		M.backcolor(frame,0,0,0)
		if not (strelki.yay_:IsPlaying() or strelki.yay:IsPlaying()) then
			strelki.yay_:Play()
		end
	end)
	
	frame.postupd = M.null
	bt.num = num
	bt.up = make_ud(frame,num,1,max_h)
	bt.down = make_ud(frame,num,-1,min_h)
	
	bt:SetScript("OnMouseDown",function(self)
		frame.postupd()
		if V.chatcur[bt.num] == min_h then
			V.chatcur[bt.num] = max_h
			self.down:Hide()
			self.up:Show()
		else 
			V.chatcur[bt.num] = min_h
			self.up:Hide()
			self.down:Show()
		end
	end)
end

mk_frbutton(chatone,1)
mk_frbutton(chattwo,2)	

local right_holder = CreateFrame("Frame",nil,UIParent)
right_holder:SetHeight(20)
right_holder:SetFrameStrata("LOW")

local moving = function(self,t)
	self.he = self.he + t*self.mult
	if self.he*self.ar < self.ma*self.ar then
		right_holder:ClearAllPoints()
		right_holder:SetPoint("BOTTOMRIGHT",chattwo,0,self.he)
		right_holder:SetPoint("BOTTOMLEFT",chattwo,0,self.he)
	else
		right_holder:ClearAllPoints()
		right_holder:SetPoint(self.point1,chattwo,self.point2,0,self.p)
		right_holder:SetPoint(self.point3,chattwo,self.point4,0,self.p)
		self:Hide()
	end
end

right_holder.mover = CreateFrame("Frame",nil,right_holder)
right_holder.mover:Hide()
right_holder.mover:SetScript("OnUpdate",moving)
chattwo.right_holder = right_holder

local fn_button = CreateFrame("Frame",nil,UIParent)
local work_unit = M.frame(right_holder)
chattwo.work_unit = work_unit

local hld_correct = function(he,ar,ma,mult,p1,p2,p3,p4,x,pi)
	local a = right_holder.mover
	a:Hide()
	a.he = he
	a.ar = ar
	a.ma = ma
	a.p = pi
	a.mult = (a.he + a.ma) * mult 
	a.point1 = p1
	a.point2 = p2
	a.point3 = p3
	a.point4 = p4
	a:Show()
	V.holder_cur = x
	fn_button:ClearAllPoints()
end

right_holder.go_up = function()
	hld_correct(2,1,floor(chattwo:GetHeight()),1,"BOTTOMLEFT","TOPLEFT","BOTTOMRIGHT","TOPRIGHT",1,0)
	UIFrameFadeIn(chattwo,.8,0,1)
	fr_button:EnableMouse(true)
	fn_button:SetPoint("TOPRIGHT",chattwo,5,5)
	fn_button:SetPoint("BOTTOMLEFT",chattwo,"BOTTOMRIGHT",-6,-6)
end

right_holder.go_down = function()
	hld_correct(floor(chattwo:GetHeight()),-1,2,-1,"BOTTOMLEFT","BOTTOMLEFT","BOTTOMRIGHT","BOTTOMRIGHT",0,2)
	UIFrameFadeOut(chattwo,.8,1,0)
	fr_button:EnableMouse(false)
	fn_button:SetAllPoints(work_unit)
	chattwo.update_w(0)
end

local hold_load = function()
	if not V.holder_cur then
		V.holder_cur = 1
	end
	if not V.holder_unit then
		V.holder_unit = 0
	end
	if V.holder_cur == 1 then
		right_holder.go_up()
	else
		right_holder.go_down()
	end
end

work_unit:SetPoint("RIGHT")
work_unit:SetHeight(24)
work_unit:SetFrameLevel(20)

local text_unit = M.setfont(work_unit,12,nil,nil,"CENTER")
text_unit:SetPoint("LEFT",6.4,1)
text_unit:SetPoint("RIGHT",-5.3,1)

right_holder.set_unit = function(text)
	text_unit:SetText(text)
	local a = floor(chattwo:GetWidth()/4)
	local b = string.len(text)*6
	if a < b then
		work_unit:SetWidth(a+13)
	else
		work_unit:SetWidth(b+13)
	end
end

chatone.copyb = CreateFrame("Frame",nil,chatone)
chattwo.copyb = CreateFrame("Frame",nil,right_holder)
chatone.copyb:SetSize(24,24)
chattwo.copyb:SetSize(24,24)
chatone.copyb:SetPoint("BOTTOMRIGHT",chatone,"TOPRIGHT", 0, -2)
chattwo.copyb:SetPoint("LEFT",right_holder)

local lock_chat = function(target)
	if chattwo.curent_unit then
		local a = chattwo.curent_unit
		a.st_g:SetAlpha(1)
		a.tab.lok = nil
		if text_on_right then
			a:SetJustifyH("LEFT")
		end
		a.copyb:ClearAllPoints()
		a.copyb:SetAllPoints(chatone.copyb)
		a.lok = nil
		FCF_DockFrame(a)
	end
	if target == 0 or target == 1 then
		chattwo.curent_unit = nil
		if target == 0 then
			right_holder.set_unit("NaN")
		else
			right_holder.set_unit("OFF")
		end
		chattwo.update_w(0)
	else
		local chat = _G["ChatFrame"..target]
		if not chat then return end
		FCF_UnDockFrame(chat)
		local tab = _G["ChatFrame"..target.."Tab"]
		local a = tab:GetFontString()
		a:SetAlpha(0)
		FCF_SetLocked(chat, 1)	
		tab:HookScript("OnEnter",function(self) if self.lok == true then a:SetAlpha(0); text_unit:SetTextColor(1,.7,.1) end end)
		tab:HookScript("OnLeave",function(self) if self.lok == true then a:SetAlpha(0); text_unit:SetTextColor(1,1,1)end end)
		chat:ClearAllPoints()
		tab.lok = true
		chat.lok = true
		if target == 2 then
			chat:SetPoint("TOPRIGHT", chattwo, -7, -30)
			chat:SetPoint("BOTTOMLEFT", chattwo, 7, 6)
		else
			chat:SetPoint("TOPRIGHT", chattwo, -7, -3)
			chat:SetPoint("BOTTOMLEFT", chattwo, 6, 6)
		end
		if text_on_right then
			chat:SetJustifyH("RIGHT")
		end
		tab:ClearAllPoints() 
		tab:SetAllPoints(work_unit)
		right_holder.set_unit(a:GetText())
		chat.copyb:ClearAllPoints()
		chat.copyb:SetAllPoints(chattwo.copyb)
		chattwo.curent_unit = chat
		chattwo.curent_unit.st_g = a
		chattwo.curent_unit.tab = tab
		chattwo.update_w(1)
	end
end

local check_work_mode = function(rly)
	if V.holder_cur == 1 then
		lock_chat(V.holder_unit)
	else
		if rly then
			lock_chat(V.holder_unit)
			right_holder.go_up()
		else
			lock_chat(1)
		end
	end
end

-- 2 Sceond Countdown
local t2sec = CreateFrame("Frame")
t2sec:Hide()
M.addafter(function() t2sec:Show() end)
local t2n = 2

t2sec:SetScript("OnUpdate",function(self,t)
	t2n = t2n - t
	if t2n > 0 then return end
		self:Hide()
		hold_load()
		check_work_mode()
end)

local _title = {text = "DISPLAY", isTitle = 1, notCheckable = 1}

local menuFrame = CreateFrame("Frame", "LeftChatFrameMenu", UIParent, "UIDropDownMenuTemplate")
local chatframe_menu = function()
	local abc
	if V.holder_unit ~= 0 then
		abc = {[1] = _title, [2] = {text = "NaN", func = function() V.holder_unit = 0; check_work_mode(true) end, notCheckable = 1},}
	else
		abc = {[1] = _title}
	end
	for i=2, NUM_CHAT_WINDOWS do
		if _G["ChatFrame"..i.."Tab"]:IsShown() and i~=V.holder_unit then
			local a = {text = _G["ChatFrame"..i.."Tab"]:GetFontString():GetText(),
				func = function() V.holder_unit = i; check_work_mode(true) end,
				notCheckable = 1}
			tinsert(abc,a)
		end
	end
	if V.holder_cur==1 then
		tinsert(abc,{text = "Hide Frame", func = function() right_holder.go_down(); V.holder_unit = 1; check_work_mode()  end, notCheckable = 1})
	end
	return abc
end

fn_button:SetFrameStrata("MEDIUM")
fn_button:EnableMouse(true)

fn_button:SetScript("OnMouseDown",function() EasyMenu(chatframe_menu(), menuFrame, "cursor", 0, 0, "MENU", 2) end)
fn_button:SetScript("OnEnter",function() chattwo:backcolor(0,.3,.7,.4); work_unit:backcolor(0,.3,.7,.4) end)
fn_button:SetScript("OnLeave",function() chattwo:backcolor(0,0,0); work_unit:backcolor(0,0,0) end)