addonName, addonTable = ...

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", addonTable.AutoRepair.OnMerchantShow)
f:SetScript("OnEvent", addonTable.SellPoorQuality.OnMerchantShow)
