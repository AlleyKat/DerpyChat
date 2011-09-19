local C,M,L,V = unpack(select(2,...))

local replace = string.gsub
local find = string.find
local _G = _G
local type = type

FCF_MinimizeFrame = M.null
FCF_RestorePositionAndDimensions = M.null

M.kill(InterfaceOptionsSocialPanelChatStyle)
M.kill(InterfaceOptionsSocialPanelConversationMode)
M.kill(FriendsMicroButton)
M.kill(FriendsMicroButton)
M.kill(GeneralDockManagerOverflowButton)
M.kill(GeneralDockManagerOverflowButton)


-- Player entering the world
M.addenter(function()
	
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	
	local sbut = M.frame(FirstFrameChat)
	sbut:SetSize(24,24)
	sbut:SetPoint("BOTTOMRIGHT",FirstFrameChat,"TOPRIGHT",-22,-2)

	sbutn = M.setfont(sbut,14)
	sbutn:SetPoint("CENTER",.1,.1)
	sbutn:SetText("S")
	
	_G.ChatMenu:HookScript("OnShow",function(self) 
		M.ChangeTemplate(self) 
		M.backcolor(sbut,1, 0.8, 0.15, .5)
		sbutn:SetTextColor(1, 0.8, 0.15)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT",sbut,"TOPLEFT",0,-2) 
	end)
	
	_G.ChatMenu:HookScript("OnHide",function(self) 
		M.backcolor(sbut,0,0,0)
		sbutn:SetTextColor(1, 1, 1)
	end)
	
	ChatFrameMenuButton:SetAllPoints(sbut)
	ChatFrameMenuButton:SetAlpha(0)
	ChatFrameMenuButton:SetScript("OnEnter", function() sbutn:SetTextColor(1, 0.8, 0.15) end)
	ChatFrameMenuButton:SetScript("OnLeave", function() 
		if _G.ChatMenu:IsShown() then return end
		sbutn:SetTextColor(1, 1, 1)
	end)
	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		local _G = _G
		frame:SetClampRectInsets(0,0,0,0)
		-- Hide chat buttons
		M.kill(_G["ChatFrame"..i.."ButtonFrameUpButton"])
		M.kill(_G["ChatFrame"..i.."ButtonFrameDownButton"])
		M.kill(_G["ChatFrame"..i.."ButtonFrameBottomButton"])
		M.kill(_G["ChatFrame"..i.."ButtonFrameMinimizeButton"])
		M.kill(_G["ChatFrame"..i.."ResizeButton"])
		M.kill(_G["ChatFrame"..i.."ButtonFrame"])
		
		-- Hide chat textures backdrop

		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end

		-- Stop the chat frame from fading out
		frame:SetFading(false)

		-- Change the chat frame font
		local _,x = frame:GetFont()
		frame:SetFont(M["media"].fontn, x)
		
		frame:SetFrameStrata("LOW")
		frame:SetMovable(true)
		frame:SetUserPlaced(true)
		frame:SetScale(1)
		
		GeneralDockManager:ClearAllPoints()
		GeneralDockManager:SetPoint("BOTTOMLEFT",FirstFrameChat,"TOPLEFT",0,3)
		GeneralDockManager:SetPoint("BOTTOMRIGHT",FirstFrameChat,"TOPRIGHT",-36,3)

	end
	
	-- Remember last channel
	local ChatTypeInfo = ChatTypeInfo
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	ChatTypeInfo.SAY.sticky = 1
	ChatTypeInfo.EMOTE.sticky = 1
	ChatTypeInfo.YELL.sticky = 1
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.BATTLEGROUND.sticky = 1

	ChatFrame1:SetJustifyH("LEFT")
	-- Position the general chat frame
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", FirstFrameChat,"BOTTOMLEFT", 6, 6)
	ChatFrame1:SetPoint("TOPRIGHT", FirstFrameChat,"TOPRIGHT", -7, -3)
end)

local function TempChatSkin()
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		if _G[chatFrameName].isTemporary then
				local chatFrame = _G[chatFrameName]
				local chat_name = chatFrameName
				_G[chat_name.."Tab"].noMouseAlpha = 0
				
				M.kill(_G[chatFrameName.."ButtonFrameUpButton"])
				M.kill(_G[chatFrameName.."ButtonFrameDownButton"])
				M.kill(_G[chatFrameName.."ButtonFrameBottomButton"])
				M.kill(_G[chatFrameName.."ButtonFrameMinimizeButton"])
				M.kill(_G[chatFrameName.."ResizeButton"])
				
				if _G[chatFrameName.."ConversationButton"] then
					local convo = _G[chatFrameName.."ConversationButton"]
					convo:ClearAllPoints()
					convo:SetPoint("TOPRIGHT",FirstFrameChat,-2,-2)
					convo:SetSize(26,26)
					M.ChangeTemplate(convo)
					convo:SetBackdropBorderColor(0,0,0,0)
					local texture = convo:GetNormalTexture()
					texture:SetTexture([=[Interface/Icons/Spell_ChargePositive.blp]=])
					texture:ClearAllPoints()
					texture:SetPoint("TOPLEFT",4,-4)
					texture:SetPoint("BOTTOMRIGHT",-4,4)
					texture:SetTexCoord(.1,.9,.1,.9)
					convo:GetPushedTexture():SetTexture("")
				end

				-- Stop the chat frame from fading out
				chatFrame:SetFading(false)
				
				-- Change the chat frame font
				local _,x = _G[chatFrame:GetName()]:GetFont()				
				chatFrame:SetFont(M["media"].fontn,x)
				chatFrame:SetFrameStrata("LOW")
				chatFrame:SetMovable(true)
				chatFrame:SetUserPlaced(true)
				chatFrame:SetHeight(floor(ChatFrame1:GetHeight()+.5))
				chatFrame:SetWidth(floor(ChatFrame1:GetWidth()+.5))
				chatFrame:SetClampRectInsets(0,0,0,0)
				
				M.MakeCopyButton(nil,chatFrame)
				
				-- Hide tab texture
				for j = 1, #CHAT_FRAME_TEXTURES do
					_G[chat_name..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
				end
				break
		end
	end
end
hooksecurefunc("FCF_OpenTemporaryWindow", TempChatSkin)

-- scroll
local ScrollLines = 3
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end

-- Lock it all
M.addafter(function()
	local a = 30
	local ch = V.holder_unit
	if ch ~= 0 and ch ~= 1 and ch then
		a = ch
		FCF_SetLocked(_G["ChatFrame"..a],1)
	end
	for i=1, NUM_CHAT_WINDOWS do
		if i ~= a then
			if _G["ChatFrame"..i.."Tab"]:IsShown() then
				local p = _G["ChatFrame"..i]
				FCF_DockFrame(p)
				FCF_SetLocked(p,1)
			end
		end
	end
end)
