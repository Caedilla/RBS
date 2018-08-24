local RBS = RBS or LibStub("AceAddon-3.0"):NewAddon("RBS")
local LSM = LibStub("LibSharedMedia-3.0")
local cfg = {
	Border = {
		edgeFile = [[Interface\ChatFrame\ChatFrameBackground]], -- Pixel Border settings. 
		edgeSize = 1,
	},
}

function RBS:Setup()
	for i=1,12 do
	local bagslots = GetContainerNumSlots(i-1)
	if not bagslots then bagslots = 0 end
	if bagslots == 0 then return end	
	_G["ContainerFrame"..i.."BackgroundTop"]:SetPoint("TOPLEFT",5000,5000)
	_G["ContainerFrame"..i.."BackgroundMiddle1"]:SetPoint("TOPLEFT",5000,5000)
	_G["ContainerFrame"..i.."BackgroundMiddle2"]:SetPoint("TOPLEFT",5000,5000)
	_G["ContainerFrame"..i.."BackgroundBottom"]:SetPoint("TOPLEFT",5000,5000)
	if not _G["RBS"..i.."Border"] then
		local Border = CreateFrame("Frame","RBS"..i.."Border",_G["ContainerFrame"..i])
		Border:SetPoint("TOPLEFT",_G["ContainerFrame"..i],1,-1)
		Border:SetPoint("BOTTOMRIGHT",_G["ContainerFrame"..i],-1,1)
		Border:SetBackdrop(cfg.Border)
		Border:SetBackdropBorderColor(0,0,0,1)
		Border:SetFrameLevel(0)
		local Background = Border:CreateTexture("RBS1Background","BACKGROUND")
		Background:SetAllPoints(Border)
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(0,0,0,0.5)
			for j=1,bagslots do
				if not _G["RBS"..i.."Item"..j.."Border"] then
					_G["ContainerFrame"..i.."Item"..j.."NormalTexture"]:SetAlpha(0)
					local Border = CreateFrame("Frame","RBS"..i.."Item"..j.."Border",_G["ContainerFrame"..i.."Item"..j])
					Border:SetAllPoints(_G["ContainerFrame"..i.."Item"..j])	
					Border:SetBackdrop(cfg.Border)
					Border:SetBackdropBorderColor(0,0,0,1)
					Border:SetFrameLevel(0)
					local Background = Border:CreateTexture("RBS"..i.."Item"..j.."Background","BACKGROUND")
					Background:SetAllPoints(Border)
					Background:SetTexture(LSM:Fetch("background", "Solid"))
					Background:SetVertexColor(0,0,0,0.5)
				end
			end	
		end
	end
end



function RBS:OnEnable()
	-- Run the check on all of these events.
	local Monitor = CreateFrame("Frame", "RBS")
	Monitor:RegisterEvent("BAG_UPDATE")
	Monitor:RegisterEvent("PLAYER_ENTERING_WORLD")
	Monitor:SetScript("OnEvent", RBS.Setup)
	
	for i=1,12 do
		_G["ContainerFrame"..i]:HookScript("OnShow", RBS.Setup)
	end
end