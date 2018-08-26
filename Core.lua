local RBS = RBS or LibStub("AceAddon-3.0"):NewAddon("RBS", "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RBS")

local cfg = {
	Border = {
		edgeFile = [[Interface\ChatFrame\ChatFrameBackground]], -- Pixel Border settings. 
		edgeSize = 1,
	},
}
local Defaults = {
	profile = {
		BagTransparency = 0.65,
		ItemTransparency = 0.65,
		ItemZoom = 0.0,
	},
}

local Options = {
	type = "group",
	name = function(info)
		return "RBS - |cFF91BE0FRaeli's Bag Skinner|r r|cFF91BE0F" .. string.match(GetAddOnMetadata("RBS","Version"),"%d+") .."|r"
	end,
	order = 0,
	childGroups = "tab",
	args = {
		Main = {
			name = "Options",
			type = "group",
			order = 0,
			args = {
				BagTransparency = {
					name = L["Bag Transparency"],
					type = "range",
					order = 0,
					min = 0,
					max = 1,
					softMin = 0.25,
					softMax = 0.75,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RBS.db.profile.BagTransparency
					end,
					set = function(info, value)
						RBS.db.profile.BagTransparency = value
						RBS:Update()
					end,
				},
				ItemTransparency = {
					name = L["Item Transparency"],
					type = "range",
					order = 0,
					min = 0,
					max = 1,
					softMin = 0.25,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RBS.db.profile.ItemTransparency
					end,
					set = function(info, value)
						RBS.db.profile.ItemTransparency = value
						RBS:Update()
					end,
				},
				ItemZoom = {
					name = L["Item Zoom"],
					type = "range",
					order = 0,
					min = 0,
					max = 0.5,
					softMin = 0,
					softMax = 0.2,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RBS.db.profile.ItemZoom
					end,
					set = function(info, value)
						RBS.db.profile.ItemZoom = value
						RBS:Update()
					end,
				},			
			},
		},
	},
}

function RBS:Setup()
	for i=1,12 do
		local bagID = _G["ContainerFrame"..i]:GetID()
		if bagID == 0 then
			_G["ContainerFrame"..i.."Portrait"]:SetTexture(133633)
		end
		if not _G["RBS"..i.."Border"] then
			_G["ContainerFrame"..i.."BackgroundTop"]:SetPoint("TOPLEFT",5000,5000)
			_G["ContainerFrame"..i.."BackgroundMiddle1"]:SetPoint("TOPLEFT",5000,5000)
			_G["ContainerFrame"..i.."BackgroundMiddle2"]:SetPoint("TOPLEFT",5000,5000)
			_G["ContainerFrame"..i.."BackgroundBottom"]:SetPoint("TOPLEFT",5000,5000)
			local Border = CreateFrame("Frame","RBS"..i.."Border",_G["ContainerFrame"..i])
			Border:SetPoint("TOPLEFT",_G["ContainerFrame"..i],1,-1)
			Border:SetPoint("BOTTOMRIGHT",_G["ContainerFrame"..i],-1,1)
			Border:SetBackdrop(cfg.Border)
			Border:SetBackdropBorderColor(0,0,0,1)
			Border:SetFrameLevel(0)
			local Background = Border:CreateTexture("RBS"..i.."Background","BACKGROUND")
			Background:SetAllPoints(Border)
			Background:SetTexture(LSM:Fetch("background", "Solid"))
			Background:SetVertexColor(0,0,0,RBS.db.profile.BagTransparency)
			local Portrait = _G["ContainerFrame"..i.."Portrait"]
			Portrait:SetTexCoord(0.1,0.9,0.1,0.9)
			local PortraitBorder = CreateFrame("Frame","RBS"..i.."PortraitBorder",_G["ContainerFrame"..i.."PortraitButton"])
			PortraitBorder:SetAllPoints(_G["ContainerFrame"..i.."PortraitButton"])
			PortraitBorder:SetBackdrop(cfg.Border)
			PortraitBorder:SetBackdropBorderColor(0,0,0,1)
		end
		for j=1,36 do
			if not _G["RBS"..i.."Item"..j.."Border"] then
				_G["ContainerFrame"..i.."Item"..j.."NormalTexture"]:SetAlpha(0)
				--_G["ContainerFrame"..i.."Item"..j].IconBorder:Hide()--SetAlpha(0)

				--/run print(ContainerFrame1Item20.IconBorder:GetTexture())
				--/run print(ContainerFrame1Item19.IconBorder:GetVertexColor())

				--ContainerFrame5Item23.IconBorder:SetSize(0,0)
				local Border = CreateFrame("Frame","RBS"..i.."Item"..j.."Border",_G["ContainerFrame"..i.."Item"..j])
				Border:SetAllPoints(_G["ContainerFrame"..i.."Item"..j])	
				Border:SetBackdrop(cfg.Border)
				Border:SetBackdropBorderColor(0,0,0,1)
				Border:SetFrameLevel(0)
				local Background = CreateFrame("Frame","RBS"..i.."Item"..j.."Background",_G["ContainerFrame"..i.."Item"..j])
				local BackgroundTexture = Background:CreateTexture("RBS"..i.."Item"..j.."BackgroundTexture","BACKGROUND")
				local ItemIcon = _G["ContainerFrame"..i.."Item"..j.."IconTexture"]
				local Zoom = RBS.db.profile.ItemZoom
				local ZoomOther = 1- RBS.db.profile.ItemZoom
				ItemIcon:SetTexCoord(Zoom,ZoomOther,Zoom,ZoomOther)
				Background:SetAllPoints(_G["ContainerFrame"..i.."Item"..j])
				Background:SetFrameLevel(0)
				BackgroundTexture:SetAllPoints(Background)
				BackgroundTexture:SetTexture(LSM:Fetch("background", "Solid"))
				BackgroundTexture:SetVertexColor(0,0,0,RBS.db.profile.ItemTransparency)
			end
		end	
	end
end

function RBS:Update()
	for i=1,12 do
		local bagID = _G["ContainerFrame"..i]:GetID()
		if bagID == 0 then
			_G["ContainerFrame"..i.."Portrait"]:SetTexture(133633)
		end
		if _G["RBS"..i.."Border"] then
			local Background = _G["RBS"..i.."Background"]
			Background:SetVertexColor(0,0,0,RBS.db.profile.BagTransparency)
		end
		for j=1,36 do
			if _G["RBS"..i.."Item"..j.."Border"] then
				_G["ContainerFrame"..i.."Item"..j.."NormalTexture"]:SetAlpha(0)
				local Background = _G["RBS"..i.."Item"..j.."BackgroundTexture"]
				local ItemIcon = _G["ContainerFrame"..i.."Item"..j.."IconTexture"]
				local Zoom = RBS.db.profile.ItemZoom
				local ZoomOther = 1- RBS.db.profile.ItemZoom
				ItemIcon:SetTexCoord(Zoom,ZoomOther,Zoom,ZoomOther)
				Background:SetVertexColor(0,0,0,RBS.db.profile.ItemTransparency)
			end
		end	
	end
end

function RBS:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RBSDB", Defaults, true) -- Setup Saved Variables	
	self:RegisterChatCommand("RBS", "ChatCommand") -- Register /RBS command

	-- Add Options
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("RBS", Options)
	local Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	Options.args.profiles = Profiles
	Options.args.profiles.order = 99
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RBS", "RBS")
	InterfaceAddOnsList_Update()

	-- Profile Management
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function RBS:OnEnable()
	-- Run the check on all of these events.
	_G["ContainerFrame"..1]:HookScript("OnShow", RBS.Setup)
end

function RBS:ChatCommand(input)
	LibStub("AceConfigDialog-3.0"):Open("RBS")
end

function RBS:RefreshConfig()
	RBS.db.profile = self.db.profile
end