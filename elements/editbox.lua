local C,M,L,V = unpack(select(2,...))

local edit = M.frame (UIParent,30,ChatFrame1EditBox:GetFrameStrata())
	edit:SetSize(floor(_G.FirstFrameChat:GetWidth()+.5),V.replacefont == true and 20+V.font_offset or 24)
	edit:SetPoint("BOTTOM",FirstFrameChat,"TOP",0,-102)
	edit.parent = _G.FirstFrameChat
	edit:SetAlpha(1)
	edit.parent.edit = edit
edit.parent.__SetWidth = edit.parent.SetWidth
edit.parent.SetWidth = function(self,value)
	self.edit:SetWidth(value)
	self.__SetWidth(value)
end
	
local ChatFrame1EditBox = ChatFrame1EditBox
local ChatTypeInfo = ChatTypeInfo
ChatFrame1EditBox:SetFrameLevel(60)
ChatFrame1EditBox:SetFontObject(ChatFontNormal)

local on_update = M.simple_move

edit.start_go_up = function(self)
	self.mod = 1
	self.limit = -2
	self.speed = 300
	self:SetScript("OnUpdate",on_update)
	local x = self:GetAlpha()
	UIFrameFadeIn(self,.2*(1-x),x,1)
end

edit.start_go_down = function(self)
	self.mod = -1
	self.limit = -102
	self.speed = -200
	self:SetScript("OnUpdate",on_update)
	local x = self:GetAlpha()
	UIFrameFadeOut(self,.3*x,x,0)
end

edit.point_1 = "BOTTOM"
edit.point_2 = "TOP"
edit.pos = -102

local function colorize(r,g,b)
	edit.left:SetTexture(r * .9, g * .9, b * .9)
	edit.top:SetTexture(r * .9, g * .9, b * .9)
	edit.bottom:SetTexture(r * .9, g * .9, b * .9)
	edit.right:SetTexture(r * .9, g * .9, b * .9)
	edit:SetBackdropBorderColor(r * .8, g * .8 ,b * .8, .5)
end

hooksecurefunc("ChatEdit_UpdateHeader", function()
	local type = ChatFrame1EditBox:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
		local id = GetChannelName(ChatFrame1EditBox:GetAttribute("channelTarget"))
			if id == 0 then
				colorize(0,0,0)
				edit:SetBackdropBorderColor(unpack(M["media"].shadow))
			else
				colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		else
			colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
end)

M.addenter(function()
	local ChatFrame1EditBox = ChatFrame1EditBox

	local x=({ChatFrame1EditBox:GetRegions()})
		x[9]:SetAlpha(0)
		x[10]:SetAlpha(0)
		x[11]:SetAlpha(0)
	local left, mid, right = select(6, ChatFrame1EditBox:GetRegions())
		left:Hide()
		mid:Hide()
		right:Hide()
		
	ChatFrame1EditBox:ClearAllPoints();
	ChatFrame1EditBox:SetPoint("LEFT",edit,-8,0)
	ChatFrame1EditBox:SetPoint("RIGHT",edit,8,0)
	ChatFrame1EditBox:SetPoint("TOP",edit,0,0)
	ChatFrame1EditBox:SetPoint("BOTTOM",edit,0,0)
	ChatFrame1EditBox:SetAltArrowKeyMode(false)
	ChatFrame1EditBox:SetParent(UIParent)
	ChatFrame1EditBox:Hide()
	edit:Hide()
	
	ChatFrame1EditBox:HookScript("OnShow", function(self)
		edit:start_go_up()
	end)
	ChatFrame1EditBox:HookScript("OnHide", function(self)
		edit:start_go_down()
	end)	
end)