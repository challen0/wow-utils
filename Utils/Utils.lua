addonName, addonTable = ...

local AutoRepairFrame = CreateFrame("Frame")
AutoRepairFrame:RegisterEvent("MERCHANT_SHOW")
AutoRepairFrame:SetScript("OnEvent", addonTable.AutoRepair.OnMerchantShow)

local SellPoorQualityFrame = CreateFrame("Frame")
SellPoorQualityFrame:RegisterEvent("MERCHANT_SHOW")
SellPoorQualityFrame:SetScript("OnEvent", addonTable.SellPoorQuality.OnMerchantShow)
