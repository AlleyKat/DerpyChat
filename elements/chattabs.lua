----------------------------------------------------------------------
-- Copyright (c) 2007-2010 Trond A Ekseth

-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
----------------------------------------------------------------------
local C,M,L,V = unpack(select(2,...))
local enableflash = V.show_flash
local Fane = CreateFrame'Frame'
local font, fontSize = M["media"].font,12

local leftbar = M.frame(FirstFrameChat)
leftbar:SetPoint("BOTTOMLEFT",FirstFrameChat,"TOPLEFT",0,-2)
leftbar:SetPoint("BOTTOMRIGHT",FirstFrameChat,"TOPRIGHT",-44,-2)
leftbar:SetHeight(24)

local updateFS = function(self, inc, flags, ...)
	local fstring = self:GetFontString()
		if inc and enableflash then
			fstring:SetFont(font, fontSize+2)	
		else
			fstring:SetFont(font, fontSize)	
		end
		
		fstring:SetShadowOffset(1,-1)

	if((...)) then
		fstring:SetTextColor(...)
	end
	
	if not enableflash then
		fstring:SetTextColor(1,1,1)
	end
	
	if inc and enableflash then
		fstring:SetTextColor(1,0,0)
	end
end

local OnEnter = function(self)
	updateFS(self, self.ffl, 'OUTLINE', 1, 0.8, 0.15)
end

local OnLeave = function(self)
	local r, g, b
	local id = self:GetID()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b = 1, 0.8, 0.15
	elseif self.ffl then
		r, g, b = 1,0,0
	else
		r, g, b = 1, 1, 1
	end

	updateFS(self, self.ffl, nil, r, g, b)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.leftSelectedTexture.Show = M.null
		frame.middleSelectedTexture.Show = M.null
		frame.rightSelectedTexture.Show = M.null

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		frame:SetAlpha(1)

		if(i ~= 2) then
			-- Might not be the best solution, but we avoid hooking into the UIFrameFade
			-- system this way.
			frame.SetAlpha = UIFrameFadeRemoveFrame
		else
			frame.SetAlpha = ChatFrame2_SetAlpha
			frame.GetAlpha = ChatFrame2_GetAlpha

			-- We do this here as people might be using AddonLoader together with Fane.
			if(CombatLogQuickButtonFrame_Custom) then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end

		frame.Fane = true
	end

	-- We can't trust sel. :(
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame,nil, nil, 1, 0.8, 0.15)
	else
		updateFS(frame,nil, nil, 1, 1, 1)
	end
end

local black_list = V.flash_blacklist
hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local ID = frame:GetID()
	local tab = _G['ChatFrame' .. ID .. 'Tab']
	if ID < 11 and ID ~= 2 then
		if black_list[ID] then FCF_StopAlertFlash(frame); return end
	else
		if black_list[2] then FCF_StopAlertFlash(frame); return end
	end
	tab.ffl = true
	updateFS(tab, true, nil, 1,0,0)
end)

hooksecurefunc('FCF_StopAlertFlash', function(frame)
	_G['ChatFrame' .. frame:GetID() .. 'Tab'].ffl = false
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)

for i=1,10 do
	faneifyTab(_G['ChatFrame' .. i .. 'Tab'])
end

Fane:RegisterEvent'ADDON_LOADED'
Fane:SetScript('OnEvent', function(self, event, addon)
	if(addon == 'Blizzard_CombatLog') then
		self:UnregisterEvent(event)
		self[event] = nil
		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end)
