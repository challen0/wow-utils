addonName, addonTable = ...

local AutoRepairFrame = CreateFrame("Frame")
AutoRepairFrame:RegisterEvent("MERCHANT_SHOW")
AutoRepairFrame:SetScript("OnEvent", addonTable.AutoRepair.OnMerchantShow)

local AutoSellPoorQualityFrame = CreateFrame("Frame")
AutoSellPoorQualityFrame:RegisterEvent("MERCHANT_SHOW")
AutoSellPoorQualityFrame:SetScript("OnEvent", addonTable.AutoSellPoorQuality.OnMerchantShow)
