local C,M,L,V = unpack(select(2,...))

local C = select(2,...)
local REURL_COLOR = "1888FF"
local ReURL_Brackets = V.hyperlinks_show_brakets
local hyper_ = V.hyperlinks
local hi_ = V.chatplayer
local _G = _G

-- Hyperlink
-- SPACE FLOW 11111
M.addenter(function()
	local SetItemRef_orig = SetItemRef
	_G.SetItemRef = function(link, text, button, chatFrame)
		if (strsub(link, 1, 3) == "url") then
			local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
			local url = strsub(link, 5);
			if (not ChatFrameEditBox:IsShown()) then
				ChatEdit_ActivateChat(ChatFrameEditBox)
			end
			ChatFrameEditBox:Insert(url)
			ChatFrameEditBox:HighlightText()
		else
			SetItemRef_orig(link, text, button, chatFrame)
		end
	end
end)

local function ReURL_Link(url)
	if (ReURL_Brackets) then
		return " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
	else
		return " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
	end
end

local name = GetUnitName("player")
local name_low = string.lower(name)
local name_replace = "|cff"..REURL_COLOR.."*"..name.."*|r"

local hi_name = function(text)
	if not(hi_) then return end
	local t = string.find(text,name) or 0
	local t_l = string.find(text,name_low) or 0
	if t > 45 then
		text = gsub(text,name,name_replace)
	end
	if t_l~=0 then 
		text = gsub(text,name_low,name_replace)
	end
	return text
end

local ReURL_AddLinkSyntax = function(chatstring)
	if (type(chatstring) == "string") then
		local extraspace;
		if (not strfind(chatstring, "^ ")) then
			extraspace = true;
			chatstring = " "..chatstring;
		end
		chatstring = chatstring:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
		if hyper_ then
			chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", ReURL_Link("www.%1.%2"))
			chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", ReURL_Link("%1://%2"))
			chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", ReURL_Link("%1@%2%3%4"))
			chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4:%5"))
			chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4"))
		end
		chatstring = hi_name(chatstring)
		if (extraspace) then
			chatstring = strsub(chatstring, 2);
		end
	end
	return chatstring
end

local add_mess = function(self, text, ...) self:addmessage(self.ReURL_AddLinkSyntax(text), ...) end

-- Icons
local GameTooltip = GameTooltip

local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}


local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		if frame.lok then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT", 6, 24)
		else
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", -6, 24)
		end
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end

	if frame.OnHyperlinkEnter then return frame.OnHyperlinkEnter(frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if frame.OnHyperlinkLeave then return frame.OnHyperlinkLeave(frame, ...) end
end

for i=1, NUM_CHAT_WINDOWS do
	if i ~= 2 then
		local frame = _G["ChatFrame"..i]
		frame.OnHyperlinkEnter = frame:GetScript("OnHyperlinkEnter")
		frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

		frame.OnHyperlinkLeave = frame:GetScript("OnHyperlinkLeave")
		frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
		
		frame.addmessage = frame.AddMessage
		frame.AddMessage = add_mess
		frame.ReURL_AddLinkSyntax = ReURL_AddLinkSyntax
	end
end