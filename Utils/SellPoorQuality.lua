addonName, addonTable = ...

local FormatMoney = addonTable.FormatMoney
local PrintMessage = addonTable.PrintMessage
local SellPoorQuality = {}

local function FormatSoldMessage(total)
    local SoldMessage = "Sold all poor quality items for %s"
    return string.format(SoldMessage, FormatMoney(total))
end

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

function SellPoorQuality:OnMerchantShow(event)

end

addonTable.SellPoorQuality = SellPoorQuality
