local C,M,L,V = unpack(select(2,...))
-- Copy Chat (credit: shestak for this version)
local lines = {}
local frame,isf,editBox
local FirstFrameChat = C.FirstFrameChat
local SecondFrameChat = C.SecondFrameChat
local reset_copybtn = function(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local a = _G[format("ChatFrame%d",  i)].copyb
		M.backcolor(a,0,0,0)
		a.cc:SetTextColor(1,1,1)
		a.p = nil
	end
end

local function CreatCopyFrame()
	frame = M.frame(UIParent,30,"DIALOG")
	frame:SetHeight(240)
	frame:SetScale(1)
	frame:SetPoint("BOTTOMLEFT",FirstFrameChat,"BOTTOMRIGHT",-1,0)
	frame:SetPoint("BOTTOMRIGHT",SecondFrameChat,"BOTTOMLEFT",1,0)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	frame:Hide()
	M.make_plav(frame,.3)
	
	local title = M.setfont(frame,16)
	title:SetPoint("TOPLEFT",8,-6)
	frame.title_ = title
	
	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(frame:GetWidth()-40)
	editBox:SetHeight(240)
	editBox:SetScript("OnEscapePressed", function(self) frame:Hide() end)
	
	scrollArea:SetScrollChild(editBox)
	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	frame:SetScript("OnHide",reset_copybtn)
	
end

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf,name)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not frame then CreatCopyFrame() end
	frame:show()
	frame.title_:SetText("|cffeeee11CopyBox:|r "..name:GetText())
	editBox:SetText(text)
	editBox:HighlightText(0)
end

local curr_frame = V.holder_cur
local leave = function(self) if self.p then return end self.copyname:SetTextColor(1, 1, 1) end
local enter = function(self) self.copyname:SetTextColor(1, 0.8, 0.15) end
local show = function(self) self.copyb:Show() end
local hide = function(self) self.copyb:Hide() end

local MakeCopyButton = function(i,cf)
	if not cf then cf = _G[format("ChatFrame%d",  i)] end
	
	local button = CreateFrame("Button", nil, UIParent)
	
	if i == 1 or not i then
		button:SetAllPoints(FirstFrameChat.copyb)
	elseif i == curr_frame then
		button:SetAllPoints(SecondFrameChat.copyb)
	else
		button:SetAllPoints(FirstFrameChat.copyb)
	end
	
	button:SetFrameLevel(20)
	M.setbackdrop(button)
	button:SetSize(24,24)
	button:SetFrameStrata("BACKGROUND")
	
	button.idd = _G[format(cf:GetName()).."Tab"]:GetFontString()
	
	if cf:IsShown() then 
		button:Show()
	else 
		button:Hide()
	end
	
	local copyname = M.setfont(button,14,nil,nil,"CENTER")
	copyname:SetText("C")
	copyname:SetPoint("CENTER",.1,.1)
	button.copyname = copyname
	M.style(button)
	
	button:SetScript("OnClick", function(self) 
		Copy(cf,self.idd)
		reset_copybtn()
		button.p = true
		M.backcolor(self,1, 0.8, 0.15, .5)
		copyname:SetTextColor(1, 0.8, 0.15)
	end)
	
	button:SetScript("OnEnter", enter)
	button:SetScript("OnLeave", leave)
	cf:HookScript("OnShow", show)
	cf:HookScript("OnHide", hide)
	
	button.cc = copyname
	cf.copyb = button
end

for i = 1, NUM_CHAT_WINDOWS do
	MakeCopyButton(i)
end
M.MakeCopyButton = MakeCopyButton